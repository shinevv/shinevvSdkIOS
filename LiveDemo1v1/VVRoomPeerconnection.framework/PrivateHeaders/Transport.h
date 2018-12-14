#ifndef MEDIA_SOUP_TRANSPORT_H
#define MEDIA_SOUP_TRANSPORT_H

#include "handles/Handler.h"
#include "base/BaseClass.h"
#include <map>

class Producer;
class Consumer;
class RoomCallBack;

const int DEFAULT_STATS_INTERVAL = 1;

enum TransportStates {
	NEW_TRANSPORT,
	CONNECTING_TRANSPORT,
	CONNECTED_TRANSPORT,
	FAILED_TRANSPORT,
	DISCONNECTED_TRANSPORT,
	CLOSED_TRANSPORT
};

class Transport :public Handler::Listener {
public:
	class Listener {
	public:
		virtual ~Listener(){}

		virtual void TransportRequest(Json::Value data, ProcessCallBack successCallBack, ProcessCallBack failCallBack, void* userdata) = 0;

		virtual void TransportNotify(Json::Value data) = 0;

		virtual void TransportRemoveProducer(Producer* producer) = 0;
	};

	Transport(std::string direction, ROOM_OPTIONS settings, std::string mediaType, AntiWeb* anti_web, Listener* listener, RoomCallBack* room_call_back);
	virtual ~Transport();

	//inplement Handler ::Listener
	virtual void NeedCreateTransport(Json::Value transportLocalParameters, ProcessCallBack successCallBack, ProcessCallBack failCallBack, void* userdata) override;

	virtual void NeedUpdatetransport(Json::Value transportLocalParameters, ProcessCallBack successCallBack, ProcessCallBack failCallBack, void* userdata) override;

	void HandleHandler();

	int64_t GetId() {
		return _id;
	}

	bool AddProducer(Producer* producer);

	bool AddConsumer(Consumer* consumer);

	void RemoveProducer(Producer* producer);

	void PauseProducer(Producer* producer); 

	void ResumeProducer(Producer* producer);

	void RemotePause(std::string peerName, std::string kind);

	void RemoteResume(std::string peerName, std::string kind);

	void RemoveConsumer(Consumer* consumer);

	void SendPause(Consumer* consumer, bool pause);

    void TransportClosed();

private:

	bool ExecAddProducer(Producer* producer);

	bool ExecAddConsumer(Consumer* consumer);

	void ExecRemoveProducer(Producer* producer);

	void ExecPauseProducer(Producer* producer);

	void ExecResumeProducer(Producer* producer);
private:
	uint64_t _id = GetRandom();

	bool _closed = false;

	std::string _direction;

	ROOM_OPTIONS _settings = ROOM_OPTIONS(10000, false);

	std::string _mediaType;

	bool _statsEnabled = false;

	int _statsInterval = DEFAULT_STATS_INTERVAL;

	TransportStates _transport_states = TransportStates::NEW_TRANSPORT;

	Listener* _listener = NULL;

	Handler* _handle = NULL;

	RoomCallBack* _room_call_back = NULL;
};

static void* CreateProducerCallBack(std::string data, void* userdata);

static void* EnableConsumerCallBack(std::string data, void* userdata);

static void* CreateProducerFailCallBack(std::string data, void* userdata);

static void* EnableConsumerFailCallBack(std::string data, void* userdata);

#endif
