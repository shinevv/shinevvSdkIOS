#ifndef MEDIASOUP_ROOM_H
#define MEDIASOUP_ROOM_H

#include "base/BaseClass.h"
#include "mediasoup/Device.h"
#include "mediasoup/Peer.h"
#include "mediasoup/Consumer.h"
#include "mediasoup/Transport.h"
#include "mediasoup/Producer.h"
#include <stdio.h>
#include <string>
#include <map>

class RoomClient;

typedef std::map<int, Transport*> TransportMap;
typedef std::pair<int, Transport*> TransportPair;

typedef std::map<int, Producer*> ProducerMap;
typedef std::pair<int, Producer*> ProducerPair;

typedef std::map<std::string, Peer*> PeerMap;
typedef std::pair<std::string, Peer*> PeerPair;

enum Room_States {
	NEW_ROOM,
	JOINING_ROOM,
	JOINED_ROOM,
	CLOSED_ROOM
};

class Room : public Transport::Listener{
public:
	class Listener {
	public:
		virtual ~Listener(){}
		
		virtual void RoomSendRequest(Json::Value data, ProcessCallBack successCallBack, ProcessCallBack failCallBack, void* userdata) = 0;

		virtual void RoomSendNotify(Json::Value value) = 0;

		virtual void CreateTransport() = 0;
	};

	Room(ROOM_OPTIONS room_option, RoomClient* room_client, RoomCallBack* room_call_back);
	~Room();

	//inplement Transport ::Listener
	virtual void TransportRequest(Json::Value data, ProcessCallBack successCallBack, ProcessCallBack failCallBack, void* userdata) override;

	virtual void TransportNotify(Json::Value data)  override;

	virtual void TransportRemoveProducer(Producer* producer) override;

	void RemoveAllListeners() {}

	std::string GetPeerName() {
		return _peername;
	}

	std::string GetDisplayName() {
		return _displayName;
	}

	std::string GetRole() {
		return _role;
	}

	std::string GetDeviceName() {
		return _deviceName;
	}

	Listener* GetListener() {
		return (Listener*)_room_client;
	}

	AntiWeb* GetHandler();

	Room_States GetRoomStates() {
		return _room_state;
	}

	ROOM_OPTIONS GetRoomOption() {
		return _room_option;
	}

	webrtc::MediaStreamTrackInterface* GetTrack(std::string direction, std::string kind);

	bool Join(std::string displayName, std::string peerName, std::string role, std::string device, std::string extraInfoFromServer);

	void SetExtendedRtpCapabilities(Json::Value extendedRtpCapabilities);

	Transport* CreateTransport(std::string direction, std::string mediaType);

	Producer* CreateProducer(webrtc::MediaStreamTrackInterface* track, bool option, std::string media, std::string kind);

	bool HandlePeerData(Json::Value peer);

	bool HandleConsumerData(Json::Value consumer_json, Peer* peer);

	Peer* GetPeer(std::string peerName);

	void RemovePeer(std::string peerName);

	bool ConsumerPaused(int64_t id, std::string peerName);

	bool ConsumerResumed(int64_t id, std::string peerName);

	bool ConsumerClosed(int64_t id, std::string peerName);
	
	void SetPeerPause(std::string peerName, std::string source, bool pause);

	void LeaveMe();
private:
	bool QueryRoom();

	bool JoinRoom(Json::Value& peers);

	bool HandlePeers(Json::Value peers);

private:
	ROOM_OPTIONS _room_option;

	Room_States _room_state = Room_States::NEW_ROOM;

	std::string _peername;

	std::string _displayName;

	std::string _role;

	std::string _deviceName;

	TransportMap _transports_map;

	ProducerMap _producers_map;

	PeerMap _peers_map;

	RoomClient* _room_client = NULL;

	RoomCallBack* _room_call_back = NULL;

	Device* _device = NULL;

	Json::Value _extendedRtpCapabilities;
};

static void* QueryRoomCallBack(std::string data,void* userdata);

static void* JoinCallBack(std::string data, void* userdata);

static void* FailCallBack(std::string data, void* userdata);

#endif