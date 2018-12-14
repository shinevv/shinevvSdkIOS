#ifndef MEDIA_SOUP_PRODUCER_H
#define MEDIA_SOUP_PRODUCER_H

#include "base/BaseClass.h"
#include "mediasoup/Transport.h"
#include <string>

class Producer {
public:
	class Listener {
	public:
		virtual ~Listener(){}
	};

	Producer(webrtc::MediaStreamTrackInterface* track, bool option, std::string media, std::string kind);
	virtual ~Producer();

	void HandleTrack();

	void Close();

	void Pause();

	void Resume();

	bool Send(Transport* transport);

	int64_t GetId() {
		return _id;
	}

	bool GetClosed() {
		return _closed;
	}

	webrtc::MediaStreamTrackInterface* GetTrack() {
		return _originalTrack;
	}

	Transport* GetTransport() {
		return _transport;
	}

	std::string GetKind() {
		return _kind;
	}

	std::string GetMedia() {
		return _media;
	}

	void SetRtpParameters(Json::Value rtpParameters) {
		_rtpParameters = rtpParameters;
	}

	Json::Value& GetRtpParameters() {
		return _rtpParameters;
	}

	void SetLabel(std::string label) {
		_label = label;
	}

	std::string GetLabel() {
		return _label;
	}


private:
	webrtc::MediaStreamTrackInterface* _originalTrack = NULL;

	webrtc::MediaStreamTrackInterface* _track = NULL;

	std::string _kind;
	uint64_t _id = GetRandom();

	bool _closed = false;

	bool _simulcast = false;

	std::string _media;

	Transport* _transport = NULL;

	bool _locallyPaused = false;

	bool _remotelyPaused = false;

	bool _statsEnabled = false;

	int _statsInterval = 1;

	Json::Value _rtpParameters;

	std::string _label;
};
















#endif