#ifndef MEDIA_SOUP_ANTI_WEB
#define MEDIA_SOUP_ANTI_WEB

#include "base/BaseClass.h"
#include "handles/ortc/JsonCompare.h"
#include "handles/sdp/RemotePlanBSdp.h"
#include "webrtc/api/mediastreaminterface.h"
#include "webrtc/api/peerconnectioninterface.h"
#include "webrtc/modules/video_capture/video_capture.h"
#include "webrtc/modules/video_capture/video_capture_factory.h"
#include "webrtc/media/engine/webrtcvideocapturerfactory.h"
#include "webrtc/modules/utility/include/process_thread.h"
#include "protoo/protoo.h"
#include "peerconnection/peer_connection_factory_createor.h"
#include <map>
#include <string>
#include <vector>

class Producer;
class Consumer;
class RoomCallBack;
class TransportInfo;

const resip::Mime CONTEND_TYPE("application", "sdp");
const char kAudioLabel[] = "audio_label";
const char kVideoLabel[] = "video_label";
const char kStreamLabel[] = "stream_label";

class DummySetSessionDescriptionObserver
	: public webrtc::SetSessionDescriptionObserver {
public:
	static DummySetSessionDescriptionObserver* Create() {
		return
			new rtc::RefCountedObject<DummySetSessionDescriptionObserver>();
	}
	virtual void OnSuccess() {
		LOG(INFO) << __FUNCTION__;
	}
	virtual void OnFailure(const std::string& error) {
		LOG(INFO) << __FUNCTION__ << " " << error;
	}

protected:
	DummySetSessionDescriptionObserver() {}
	~DummySetSessionDescriptionObserver() {}
};

class DummyStatsObserver : public webrtc::StatsObserver {
public:
	DummyStatsObserver();

	~DummyStatsObserver();
	// StatsObserver implementation.
	virtual void OnComplete(const webrtc::StatsReports& reports) override;

	virtual int AddRef() const override { return 1; };
	virtual int Release() const override { return 0; };

	TransportInfo* GetStats() {
		return _transport_info;
	}

	bool GetIntValue(const webrtc::StatsReport* report, webrtc::StatsReport::StatsValueName name, int* value);

	bool GetStringValue(const webrtc::StatsReport* report, webrtc::StatsReport::StatsValueName name, std::string* value);
private:
	TransportInfo* _transport_info = NULL;
};

class Handler : public webrtc::PeerConnectionObserver 
			  , public webrtc::SetSessionDescriptionObserver {
public:
	class Listener {
	public:
		virtual ~Listener(){}

		virtual void NeedCreateTransport(Json::Value transportLocalParameters, ProcessCallBack successCallBack, ProcessCallBack failCallBack, void* userdata) = 0;

		virtual void NeedUpdatetransport(Json::Value transportLocalParameters, ProcessCallBack successCallBack, ProcessCallBack failCallBack, void* userdata) = 0;
	};

	Handler(std::string direction, Json::Value rtpParametersByKind, ROOM_OPTIONS settings, JsonCompare* json_compare,
		RoomCallBack* room_call_back, Listener* _listener);

	virtual ~Handler();

	virtual webrtc::AudioTrackInterface* GetAudioTrack(std::string label) = 0;

	virtual rtc::scoped_refptr<webrtc::VideoTrackInterface> GetVideoTrack(std::string label) = 0;

	virtual bool AddProducer(Producer* producer, Json::Value& rtpParameters) = 0;

	virtual bool AddConsumer(Consumer* consumer) = 0;

	virtual std::vector<TransportInfo*> GetTransportInfos() = 0;

	virtual void RemoveProducer(Producer* producer) = 0;

	virtual void RemoveConsumer(Consumer* consumer) = 0;

	virtual void TransportClosed() = 0;

	RemoteSdp* GetRemoteSdp() {
		return _remoteSdp;
	}

	// PeerConnectionObserver implementation.
	void OnSignalingChange(
		webrtc::PeerConnectionInterface::SignalingState new_state) override {};
	void OnRemoveStream(
		rtc::scoped_refptr<webrtc::MediaStreamInterface> stream) override {}
	void OnDataChannel(
		rtc::scoped_refptr<webrtc::DataChannelInterface> channel) override {}
	void OnRenegotiationNeeded() override {}
	void OnIceConnectionChange(
		webrtc::PeerConnectionInterface::IceConnectionState new_state) override {}
	void OnIceGatheringChange(
		webrtc::PeerConnectionInterface::IceGatheringState new_state) override {}
	void OnIceCandidate(const webrtc::IceCandidateInterface* candidate) override {}
	void OnIceConnectionReceivingChange(bool receiving) override {}

	virtual void OnSuccess() override{
		LOG(INFO) << __FUNCTION__;
		LocalSet(true);
	}
	virtual void OnFailure(const std::string& error) override{
		LOG(INFO) << __FUNCTION__ << " " << error;
		LocalSet(false);
	}

protected:
	bool LocalWait() {
		std::future_status status;
		status = _offer_fut.wait_for(std::chrono::milliseconds(3500));
		if (status == std::future_status::timeout) {
			return false;
		}

		bool success = _offer_fut.get();
		delete _offer_prom;
		_offer_prom = new std::promise<bool>;
		_offer_fut = _offer_prom->get_future();
		return success;
	}
	void LocalSet(bool success) {
		_offer_prom->set_value(success);
	}

protected:
	rtc::scoped_refptr<webrtc::PeerConnectionInterface> _peer_connection;

	webrtc::PeerConnectionFactoryInterface* _peer_connection_factory;

	Json::Value _rtpParametersByKind;

	RemoteSdp* _remoteSdp = NULL;

	JsonCompare* _json_compare = NULL;

	Listener* _listener = NULL;

	RoomCallBack* _room_call_back = NULL;
protected:
    void ClosePeerConnection();
	void CreatePeerConnection();
                  
private:
	std::promise<bool>* _offer_prom = new std::promise<bool>;
	std::future<bool> _offer_fut = _offer_prom->get_future();
};

class SendHandler : public Handler ,
					public webrtc::CreateSessionDescriptionObserver {
public:
	SendHandler(Json::Value rtpParametersByKind, ROOM_OPTIONS settings, JsonCompare* json_compare, RoomCallBack* room_call_back, Listener* _listener);

	virtual ~SendHandler();

    // PeerConnectionObserver implementation.
    void OnAddStream(rtc::scoped_refptr<webrtc::MediaStreamInterface> stream) override{}
                        
	virtual webrtc::AudioTrackInterface* GetAudioTrack(std::string label) override;

	virtual rtc::scoped_refptr<webrtc::VideoTrackInterface> GetVideoTrack(std::string label) override;

	virtual bool AddProducer(Producer* producer, Json::Value& rtpParameters) override;

	virtual bool AddConsumer(Consumer* consumer) override { return true; }

	virtual std::vector<TransportInfo*> GetTransportInfos() override;

	virtual void RemoveProducer(Producer* producer) override;

	virtual void RemoveConsumer(Consumer* consumer) override {}

	virtual void TransportClosed() override {}

	bool SetRemoteSdp(resip::SdpContents offerSdp);

	void SetTransport(bool ok) {
		_transport_ready = ok;
	}

	void PrepareVideoTrack();

	void PrepareAudioTrack();

	// The implementation of the CreateSessionDescriptionObserver takes
	// the ownership of the |desc|.
	virtual void OnSuccess(webrtc::SessionDescriptionInterface* desc) override;
	virtual void OnFailure(const std::string& error) override;
	virtual int AddRef() const override { return 1; };
	virtual int Release() const override { return 0; };

private:
	void AddVideoTrack(webrtc::VideoTrackInterface* track);

	void AddAudioTrack(webrtc::AudioTrackInterface* track);

	void SetupTransport(resip::SdpContents offerSdp, AppData* appdata);


private:
	rtc::scoped_refptr<webrtc::AudioTrackInterface> _audio_track;
	rtc::scoped_refptr<webrtc::VideoTrackInterface> _video_track;
    rtc::scoped_refptr<webrtc::MediaStreamInterface> _send_stream;


	webrtc::SessionDescriptionInterface* _offer = NULL;

	bool _transport_ready = false;

	DummyStatsObserver* _stats_observer = NULL;
};

class RecvHandler : public Handler ,
					public webrtc::CreateSessionDescriptionObserver {
public:
	RecvHandler(Json::Value rtpParametersByKind, ROOM_OPTIONS settings, JsonCompare* json_compare, RoomCallBack* room_call_back, Listener* _listener);
	virtual ~RecvHandler();
                        
    // PeerConnectionObserver implementation.
    void OnAddStream(rtc::scoped_refptr<webrtc::MediaStreamInterface> stream) override;

	virtual webrtc::AudioTrackInterface* GetAudioTrack(std::string label) override;

	virtual rtc::scoped_refptr<webrtc::VideoTrackInterface> GetVideoTrack(std::string label) override;

	virtual bool AddProducer(Producer* producer, Json::Value& rtpParameters) override {return true;}

	virtual bool AddConsumer(Consumer* consumer) override;

	virtual void RemoveProducer(Producer* producer) override {}

	virtual void RemoveConsumer(Consumer* consumer) override;

	virtual void TransportClosed() override;

	virtual std::vector<TransportInfo*> GetTransportInfos() override;

	void SetTransport(bool ok) {
		_transport_created = ok;
	}

	// The implementation of the CreateSessionDescriptionObserver takes
	// the ownership of the |desc|.
	virtual void OnSuccess(webrtc::SessionDescriptionInterface* desc) override;

	virtual void OnFailure(const std::string& error) override;

	virtual int AddRef() const override { return 1; };

	virtual int Release() const override { return 0; };
private:
	void SetupTransport(AppData *appdata);

	bool SetRemoteSdp();

	void UpdateTransport();

private:
	std::map<int, ConsumerInfos*> _consumer_infos_map;

	std::vector<std::string> _kinds_vector;

    rtc::scoped_refptr<webrtc::MediaStreamInterface> _rec_stream;

	std::map<webrtc::VideoTrackInterface*, std::string> _peerName_track_map;

	webrtc::SessionDescriptionInterface* _answer = NULL;

	bool _transport_created = false;

	bool _transport_updated = false;

	DummyStatsObserver* _stats_observer = NULL;
};

class AntiWeb : public webrtc::CreateSessionDescriptionObserver,
					   webrtc::PeerConnectionObserver  {
public:

	AntiWeb(RoomCallBack* room_call_back);
	virtual ~AntiWeb();

	Json::Value& GetNativeRtpCapabilities();

	JsonCompare* GetJsonCompare() {
		return _json_compare;
	}

	Handler* GetHandler(std::string direction, ROOM_OPTIONS settings, Handler::Listener* _listener);

	virtual void OnSuccess(webrtc::SessionDescriptionInterface* desc) override;
	virtual void OnFailure(const std::string& error) override;

	// PeerConnectionObserver implementation.
	void OnSignalingChange(
		webrtc::PeerConnectionInterface::SignalingState new_state) override {};
	void OnAddStream(
		rtc::scoped_refptr<webrtc::MediaStreamInterface> stream) override {};
	void OnRemoveStream(
		rtc::scoped_refptr<webrtc::MediaStreamInterface> stream) override {};
	void OnDataChannel(
		rtc::scoped_refptr<webrtc::DataChannelInterface> channel) override {}
	void OnRenegotiationNeeded() override {}
	void OnIceConnectionChange(
		webrtc::PeerConnectionInterface::IceConnectionState new_state) override {};
	void OnIceGatheringChange(
		webrtc::PeerConnectionInterface::IceGatheringState new_state) override {};
	void OnIceCandidate(const webrtc::IceCandidateInterface* candidate) override {};
	void OnIceConnectionReceivingChange(bool receiving) override {}

	virtual int AddRef() const override { return 1; };
	virtual int Release() const override { return 0; };

private:
	bool AddStreams();

	void RtpCapabiliesToJson(resip::SdpContents sdp);
	void CodecToJson(Json::Value &codecs,resip::SdpContents::Session::Medium audioSessionCaps,std::string kind);
	void HeaderExtensionsToJson(Json::Value &headerextensions, resip::SdpContents::Session::Medium audioSessionCaps, std::string kind);
	void CreateOffer();
	std::vector<std::string> Split(std::string strtem, char* a);

	void DestoryPeerconnection();

	rtc::scoped_refptr<webrtc::PeerConnectionInterface> _peer_connection;

	webrtc::PeerConnectionFactoryInterface* _peer_connection_factory = NULL;
	rtc::scoped_refptr<webrtc::AudioTrackInterface> _audio_track;
	rtc::scoped_refptr<webrtc::VideoTrackInterface> _video_track;
	rtc::scoped_refptr<webrtc::MediaStreamInterface> _stream;


	Json::Value	_native_capabilities;

	Handler* _send_handler = NULL;

	Handler* _recv_handler = NULL;

	JsonCompare* _json_compare = new JsonCompare();

	std::unique_ptr<webrtc::CriticalSectionWrapper> _native_capabilities_lock_;

	RoomCallBack* _room_call_back = NULL;
};

std::string GetPeerConnectionString();
std::string GetEnvVarOrDefault(const char* env_var_name, const char* default_value);

static void* SendCreateTransportProcessCallBack(std::string data, void* userdata);

static void* RecvCreateTransportProcessCallBack(std::string data, void* userdata);

static void* FailProcessCallBack(std::string data, void* userdata);
#endif
