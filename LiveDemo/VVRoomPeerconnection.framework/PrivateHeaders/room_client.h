#ifndef ROOM_CLIENT_H
#define ROOM_CLIENT_H

#include "base/BaseClass.h"
#include "protoo/protoo.h"
#include "mediasoup/Room.h"
#include <string>
#include <vector>

typedef struct _PeerInfo{
public:
	_PeerInfo(std::string peerName, std::string displayName, std::string role)
		: _peerName(peerName)
		, _displayName(displayName)
		, _role(role) {}

	_PeerInfo(std::string peerName, std::string displayName, std::string role, std::string _source)
		: _peerName(peerName)
		, _displayName(displayName)
		, _role(role) 
		, _source(_source) {}

	Json::Value ToJson() {
		Json::Value data(Json::objectValue);
		data["peerName"] = _peerName;
		data["peerId"] = _peerName; //  duplicated, just adapter to app data struct
		data["displayName"] = _displayName;
		data["nickName"] = _displayName; // duplicated, just adapter to app data struct
		data["role"] = _role;
		data["source"] = _source;

		return data;
	}

	std::string _peerName;
	std::string _displayName;
	std::string _role;
	std::string _source;
}PeerInfo;

class TransportInfo {
public:
	enum TransportLevel {
		LOW,
		WEEK,
		MIDDLE,
		HIGH
	};

	TransportInfo() {}
	TransportInfo(std::string peerName, TransportLevel level, int fps, int packets, int packetLoss, int bytes, float lossRate, int currentDelayMs)
		: _peerName(peerName)
		, _level(level)
		, _fps(fps)
		, _packets(packets)
		, _packetLoss(packetLoss)
		, _bytes(bytes)
		, _lossRate(lossRate)
		, _currentDelayMs(currentDelayMs){}

	Json::Value ToJson() {
		Json::Value data(Json::objectValue);
		data["peerName"] = _peerName;
		data["peerId"] = _peerName; // just adapter to app data struct
		data["level"] = (int)_level;
		data["fps"] = _fps;
		data["packets"] = _packets;
        data["packetLoss"] = _packetLoss;
		data["bytes"] = _bytes;
		data["lossRate"] = _lossRate;
        data["currentDelayMs"] = _currentDelayMs;

		return data;
	}

	std::string _peerName;
	TransportLevel _level = TransportLevel::LOW;
	int _fps = 0;
	int _packets = 0;
	int _packetLoss = 0;
	int _bytes = 0;
	float _lossRate = 0.0;
	int _currentDelayMs = 0;
} ;

class RoomCallBack {
public:
	virtual ~RoomCallBack() {}

	/**
	 * websockt连接成功
	 */
	virtual void OnConnected() = 0;

	/**
	 * websocket连接失败
	 */
	virtual void OnConnectFail() = 0;

	/**
	 * 收到websocket消息
	 * @param method
	 * @param data
	 */
	virtual void OnRecvRequest(std::string method, std::string data) = 0;

	/**
	 * 创建音视频失败
	 * @param error
	 */
	virtual void OnCreateSessionFail(std::string error) = 0;

	/**
	* 返回音频创建状态
	* @param bSuccess
	*/
	virtual void OnCreateLocalAudio(bool bSuccess) = 0;

	/**
	* 返回视频创建状态
	* @param bSuccess
	*/
	virtual void OnCreateLocalVideo(bool bSuccess) = 0;

	/**
	 * 创建本地视频成功
	 * @param track
	 */
	virtual void OnOpenVideoDeviceSuccess(rtc::scoped_refptr<webrtc::VideoTrackInterface> track) = 0;

	/**
	 * 创建远端视频会话成功
	 * @param track
	 * @param displayName
	 * @param peerName
	 * @param role
	 */
	virtual void OnAddRemoteVideoStreamSuccess(rtc::scoped_refptr<webrtc::VideoTrackInterface> track, PeerInfo peerInfo) = 0;

    /**
	 * 远端视频关闭
	 * @param peerName
	 * @param kind
	 */
    virtual void OnConsumerStreamClosed(std::string peerName, std::string kind, std::string source) = 0;

    /**
	 * 远端音频开启
	 * @param peerName
	 * @param kind
	 */
	virtual void OnConsumerResume(std::string peerName, std::string kind) = 0;

	/**
	 * 远端音频暂停
	 * @param peerName
	 * @param kind
	 */
	virtual void OnConsumerPause(std::string peerName, std::string kind) = 0;


	/**
	 * 本端音频/视频被关闭/开启
	 * @param kind
	 * @param status
	 */
	virtual void OnRecvTrackSlient(std::string kind, bool status) = 0;

	/**
	 * 开始上课
	 * @param peerinfos，当前成员信息
	 */
	virtual void OnClassStart(std::vector<PeerInfo> peerinfos, std::string extraInfoFromServer) = 0;

	/**
	 * 结束上课
	 */
	virtual void OnClassOver() = 0;

	/**
	 * 新成员加入
	 * @param peerName
	 * @param displayName
	 */
	virtual void OnNewPeer(PeerInfo peerInfo) = 0;

	/**
	 * 成员退出
	 * @param peerName
	 */
	virtual void OnPeerClose(std::string peerName) = 0;

	/**
	 * 传输状态回调
	 * @param transportinfos
	 */
	virtual void OnTransportStatus(std::vector<TransportInfo*> transportInfos) = 0;
};

class RoomClient : public Room::Listener
	, Peer::Listener
	, Consumer::Listener 
	, ProtooRecvRequestCallBack
	, sigslot::has_slots<> 
	, webrtc::Module {
public:
	RoomClient(std::string token, std::string roomId, std::string kind, std::string peerName, std::string displayName, 
		std::string role, std::string device, RoomCallBack* track_call_back);

	virtual ~RoomClient();

	void setRole(std::string role);

	void ConnectRequestRoom(std::string serverIP, int serverPort, int timeout_ms);

	void LeaveRoom();

	void SendRequest(std::string data, ProcessCallBack successCallBack, ProcessCallBack failCallBack, void* userdata, bool notify = false);

	void QueryRoomData(std::string data
			, ProcessCallBack successCallBack, ProcessCallBack failCallBack, void* userdata);

	void SendRouteRequest(std::string data
			, ProcessCallBack successCallBack, ProcessCallBack failCallBack, void* userdata);

	void SendPPTRequest(std::string data
			, ProcessCallBack successCallBack, ProcessCallBack failCallBack, void* userdata);

	void SendVideoRequest(std::string data
			, ProcessCallBack successCallBack, ProcessCallBack failCallBack, void* userdata);

	void SendChatRequest(std::string data
			, ProcessCallBack successCallBack, ProcessCallBack failCallBack, void* userdata);

	void SendPathRequest(std::string data
			, ProcessCallBack successCallBack, ProcessCallBack failCallBack, void* userdata);

	/**
	 * 申请授权/举手
	 * @param data
	 * @param successCallBack
	 * @param failCallBack
	 * @param userdata
	 */
	void SendReqContentControlRequest(std::string data
			, ProcessCallBack successCallBack, ProcessCallBack failCallBack, void* userdata);

	/**
	 * 授权 老师/助教给学生/旁听首选
	 * @param data
	 * @param successCallBack
	 * @param failCallBack
	 * @param userdata
	 */
	void SendContentControlAuthRequest(std::string data
			, ProcessCallBack successCallBack, ProcessCallBack failCallBack, void* userdata);

	void DisableCamera();

	void EnableCamera();

	void MuteMic();

	void UnMuteMic();

	void SlientTrack(std::string kind, std::string peerName, bool status);

	void SetPeerPause(std::string peerName, std::string source, bool pause);

	void AddRolesForAudioVideo(std::string role);

	/// impl Room::Listener
	virtual void RoomSendRequest(Json::Value data, ProcessCallBack successCallBack, ProcessCallBack failCallBack, void* userdata) override;

	virtual void RoomSendNotify(Json::Value data)  override;

	virtual void CreateTransport() override;

	/// impl  Consumer::Listener 
	virtual void Close(int64_t id) override {}

	virtual void Close(int64_t id, std::string originator) override;

	/// impl Peer::Listener
	virtual bool NewConsumer(Consumer* consumer) override;

	/// impl ProtooRecvRequestCallBack
	virtual void RecvData(std::string recMethod, std::string data) override;

	virtual void OnProtooConnected(int code) override;

	virtual void OnProtooDisConnected() override;

private:
	void OnJoinMe(std::string extraInfoFromServer);

	void OnLeaveMe();

	bool Join(std::string displayName, std::string device, std::string extraInfoFromServer);

	bool JoinRoom(std::string displayName, std::string device, std::string extraInfoFromServer);

	bool HandleConsumer(Consumer* consumer);

	bool SetMicProducer();

	bool EnableWebcam();

	void ActiveSpeakerCallBack(Json::Value value);

	void TrackSlient(Json::Value data);

	void ConsumerEffectiveProfileChangedCallBack(Json::Value value);

	void SignalThreadDestroyed();

	//impl webrtc::Module
	virtual int64_t TimeUntilNextProcess() override;

	virtual void Process() override;

private:
	std::unique_ptr<webrtc::CriticalSectionWrapper> _network_lock;
//	Network* _network = NULL;

	ProtooClient* _protoo = NULL;

	std::string _peerName;
	// Closed flag.
	bool _closed = false;

	// Whether we should produce.
	void *_produce = NULL;

	// Whether simulcast should be used.
	void *_useSimulcast = NULL;

	// Redux store dispatch function.
	void *_dispatch = NULL;

	// Redux store getState function.
	void *_getState = NULL;

	// mediasoup-client Room instance.
	Room* _room = NULL;

	// Transport for sending.
	Transport* _sendTransport = NULL;

	// Transport for receiving.
	Transport* _recvTransport = NULL;

	// Local mic mediasoup Producer.
	Producer* _micProducer = NULL;

	// Local webcam mediasoup Producer.
	Producer* _webcamProducer = NULL;

	std::unique_ptr<webrtc::ProcessThread> _working_thread;

	RoomCallBack* _room_call_back = NULL;

	std::string _token;

	std::string _roomId;

	std::string _displayName;

	std::string _role;

	std::string _device;

	std::string _kind;

	std::vector<std::string> _ignoreRolesForAudioVideo;

	bool _in_room = true;
};

#endif