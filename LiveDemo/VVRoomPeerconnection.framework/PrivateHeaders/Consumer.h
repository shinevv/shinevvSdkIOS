#ifndef MEDIA_SOUP_CONSUMER_H
#define MEDIA_SOUP_CONSUMER_H

#include "base/BaseClass.h"
#include "mediasoup/Transport.h"
class Peer;

class Consumer {
public:
	class Listener {
	public:
		virtual ~Listener(){}
		virtual void Close(int64_t id) = 0;
		virtual void Close(int64_t id, std::string originator) = 0;
	};

	Consumer(int64_t id, std::string kind, Json::Value rtpParamters, Peer* peer, std::string source, Listener* listener);
	
	virtual ~Consumer();

	bool Receive(Transport* transport);

	void SetSupported(bool support) {
		_supported = support;
	}

	int64_t GetId() {
		return _id;
	}

	Json::Value& GetRtpParamters() {
		return _rtpParamters;
	}

	std::string GetKind() {
		return _kind;
	}

	bool GetLocallyPaused() {
		return _locallyPaused;
	}

	void SetLocallyPaused(bool pause) {
		_locallyPaused = pause;
	}

	bool GetRemotelyPaused() {
		return _remotelyPaused;
	}

	std::string& GetPreferredProfile() {
		return _preferredProfile;
	}

	Peer* GetPeer() {
		return _peer;
	}

	void SetTrack(webrtc::MediaStreamTrackInterface* track) {
		_track = track;
	}

	bool RemotePause();

	bool RemoteResume(); 

	void RemoteClose();

	void SendPause(bool pause);

	std::string  GetSource() {
		return _source;
	}

	void SetLabel(std::string label) {
		_label = label;
	}

	std::string GetLabel() {
		return _label;
	}

private:
	int64_t _id = 0;

	bool _close = false;

	std::string _kind;

	Json::Value _rtpParamters;

	Peer* _peer = NULL;

	std::string _source;

	bool _supported = true;

	Transport* _transport = NULL;

	std::string _preferredProfile = "default";

	bool _locallyPaused = false;

	bool _remotelyPaused = false;

	std::string _label;

	webrtc::MediaStreamTrackInterface* _track = NULL;

	Listener* _listener = NULL;
};







#endif