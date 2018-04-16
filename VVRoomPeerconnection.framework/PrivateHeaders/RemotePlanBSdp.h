#ifndef MEDIA_SOUP_REMOTE_PLANB_SDP_H
#define MEDIA_SOUP_REMOTE_PLANB_SDP_H

#include "base/BaseClass.h"
#include "webrtc/api/mediastreaminterface.h"
#include "webrtc/api/peerconnectioninterface.h"
#include "third_party/resiprocate-1.10.0/resip/stack/HeaderFieldValue.hxx"
#include "third_party/resiprocate-1.10.0/resip/stack/SdpContents.hxx"
#include "third_party/resiprocate-1.10.0/resip/stack/Mime.hxx"
#include <list>
#include <vector>

typedef struct _SdpGlobalFields {
public:
	_SdpGlobalFields(int id, int version) :_id(id), _version(version) {}
	_SdpGlobalFields() {}
	uint64_t _id = GetRandom();
	int _version = 0;
}SdpGlobalFields;

class RemoteSdp {
public:
	RemoteSdp(Json::Value rtpParametersByKind);
	virtual ~RemoteSdp();

	void SetTransportLocalParameters(Json::Value transportLocalParameters);

	void SetTransportRemoteParameters(Json::Value transportRemoteParameters);

	virtual void CreateAndwerSdp(std::string type, resip::SdpContents Sdp, webrtc::SessionDescriptionInterface** session_description) = 0;

	virtual void CreateOfferSdp(std::string type, std::vector<std::string> kinds, std::vector<ConsumerInfos*> consumer_infos,
		webrtc::SessionDescriptionInterface** session_description) = 0;

	virtual void FillRtpParametersForTrack(Json::Value& rtpParameters, std::string kind, resip::SdpContents local_sdp) = 0;
protected:
	Json::Value				_rtpParametersByKind;
	SdpGlobalFields			_sdpGlobalFields;
	Json::Value				_transportLocalParameters;
	Json::Value				_transportRemoteParameters;
};

class SendRemoteSdp : public RemoteSdp {
public:
	SendRemoteSdp(Json::Value rtpParametersByKind);
	~SendRemoteSdp();

	virtual void CreateAndwerSdp(std::string type, resip::SdpContents Sdp, webrtc::SessionDescriptionInterface** session_description) override;

	virtual void CreateOfferSdp(std::string type, std::vector<std::string> kinds, std::vector<ConsumerInfos*> consumer_infos,
		webrtc::SessionDescriptionInterface** session_description) override {}

	virtual void FillRtpParametersForTrack(Json::Value& rtpParameters, std::string kind, resip::SdpContents local_sdp) override;
};

class RecvRemoteSdp :	public RemoteSdp {
public:
	RecvRemoteSdp(Json::Value rtpParametersByKind);
	~RecvRemoteSdp();

	virtual void CreateAndwerSdp(std::string type, resip::SdpContents Sdp, webrtc::SessionDescriptionInterface** session_description) override {}

	virtual void CreateOfferSdp(std::string type, std::vector<std::string> kinds, std::vector<ConsumerInfos*> consumer_infos
	, webrtc::SessionDescriptionInterface** session_description) override;

	virtual void FillRtpParametersForTrack(Json::Value& rtpParameters, std::string kind, resip::SdpContents local_sdp) override {}
private:
	std::string _streamId;
};

class RemotePlanBSdp {
public:
	RemotePlanBSdp();
	~RemotePlanBSdp();

	RemoteSdp* GetRemotePlanBSdp(std::string direction, Json::Value rtpParametersByKind);
};

#endif