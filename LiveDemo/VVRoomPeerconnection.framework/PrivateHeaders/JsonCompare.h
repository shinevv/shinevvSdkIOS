#ifndef MEDIA_SOUP_JSON_COMPARE_H
#define MEDIA_SOUP_JSON_COMPARE_H

#include "base/BaseClass.h"
#include <string>

class JsonCompare {
public:
	JsonCompare();
	~JsonCompare();

	Json::Value& GetExtendedRtpCapabilities(Json::Value native_capabilities, Json::Value remote_capabilities);

	Json::Value& GetEffectiveRtpCapabilities();

	bool CanSend(std::string kind); 

	bool CanReceive(Json::Value rtpParameters);

	Json::Value& GetSendingRtpParameters(std::string kind);

	Json::Value& GetReceivingRtpParameters(std::string kind);
private:
	void GetExtendedCodecs(Json::Value& extended_codecs, const Json::Value native_codecs, const Json::Value remote_codecs);

	void GetExtendedHeaderExtensions(Json::Value& extended_headerextensions, const Json::Value native_headerextensions, const Json::Value remote_headerextensions);

	void GetEffectiveCodecs(Json::Value& effective_codecs);

	void GetEffectiveHeaderExtensions(Json::Value& effective_headerextensions);

	void GetChild(Json::Value& extended_childs, const Json::Value native_childs, const Json::Value remote_childs);

	Json::Value _extended_capabilities = Json::objectValue;
	Json::Value _effective_capabilities = Json::objectValue;
};











#endif