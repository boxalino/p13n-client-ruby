namespace java com.boxalino.p13n.admin.thrift
namespace php  com.boxalino.p13n.admin.thrift

struct ProfilePropertyValue {
  1: string profileId,
  2: string propertyName,
  3: string propertyValue, 
  4: i32 confidence
}

exception P13nServiceException {
  1: required string message
}

service P13nAdminService {
  binary uploadChoiceConfiguration(binary xmlPayload) throws (1: P13nServiceException p13nServiceException),
  i32 saveProfileProperties(list<ProfilePropertyValue> profilePropertyValues) throws (1: P13nServiceException p13nServiceException),
  i32 replaceProfileProperties(list<ProfilePropertyValue> profilePropertyValues) throws (1: P13nServiceException p13nServiceException),
  string command(string command) throws (1: P13nServiceException p13nServiceException),
}