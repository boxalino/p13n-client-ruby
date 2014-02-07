namespace java com.boxalino.p13n.api.thrift
namespace php  com.boxalino.p13n.api.thrift

struct Filter {
  1: bool negative,
  2: string fieldName,
  3: list<string> stringValues,
  4: string prefix,
  5: list<string> hierarchy,
  6: string rangeFrom,
  7: bool rangeFromInclusive,
  8: string rangeTo,
  9: bool rangeToInclusive
}

enum DateRangeGap {
  SECOND = 1, 
  MINUTE = 2, 
  HOUR = 3, 
  DAY = 4, 
  WEEK = 5, 
  MONTH = 6, 
  YEAR = 7, 
  DECADE = 8, 
  CENTURY = 9
}

enum FacetSortOrder {
  POPULATION = 1,
  COLLATION = 2
}

struct FacetRequest {
  1: string fieldName,
  2: bool numerical,
  3: bool range,
  4: i32 maxCount = -1,
  5: i32 minPopulation = 1,
  6: DateRangeGap dateRangeGap,
  7: FacetSortOrder sortOrder,
  8: bool sortAscending
}

struct SortField {
  1: string fieldName,
  2: bool reverse
}

struct SimpleSearchQuery {
  1: string indexId,
  2: string language,
  3: string queryText,
  4: list<Filter> filters,
  5: bool orFilters,
  6: list<FacetRequest> facetRequests,
  7: list<SortField> sortFields,
  8: i64 offset,
  9: i32 hitCount,
 10: list<string> returnFields
}

struct ContextItem {
  # id of the index to fetch context item data from
  1: string indexId,
  # the field name of the item's unique identifier within the items index
  # for example: 'sku' for items 'products' 
  2: string fieldName,
  # actual item's identifier
  # for example: actual sku of the product
  3: string contextItemId,
  # role of the item within the context, used to address the item in the recommendation.
  # for example: 'main product' for recommendations within product detail page
  4: string role
}

struct ChoiceInquiry {
  1: string choiceId,
  2: SimpleSearchQuery simpleSearchQuery,
  3: list<ContextItem> contextItems, 
  4: i32 minHitCount
}

struct RequestContext {
  1: map<string,list<string>> parameters
}

struct ChoiceRequest {
  1: string authenticationToken,
  2: string profileId,
  3: list<ChoiceInquiry> inquiries,
  4: RequestContext requestContext
}

struct FacetValue {
  1: string stringValue,
  2: string rangeFromInclusive,
  3: string rangeToExclusive,
  4: i64 hitCount;
}

struct FacetResponse {
  1: string fieldName,
  2: list<FacetValue> values
}

struct Hit {
  1: map<string, list<string>> values,
  2: double score
}

struct SearchResult {
  1: list<Hit> hits,
  2: list<FacetResponse> facetResponses,
  3: i64 totalHitCount
}

struct Variant {
  1: string variantId,
  2: string scenarioId,
  3: SearchResult searchResult,
  4: string searchResultTitle
}

struct ChoiceResponse {
  1: list<Variant> variants
}

struct ProfilePropertyValue {
  1: string profileId,
  2: string propertyName,
  3: string propertyValue, 
  4: i32 confidence
}

struct BatchChoiceRequest {
  1: string authenticationToken,
  2: ChoiceInquiry choiceInquiry,
  3: RequestContext requestContext
  4: list<string> profileIds
}

struct BatchChoiceResponse {
  1: list<Variant> variants
}

exception P13ServiceException {
  1: required string message
}

service P13nService {
  ChoiceResponse choose(ChoiceRequest choiceRequest) throws (1: P13ServiceException p13ServiceException),
  binary uploadChoiceConfiguration(binary xmlPayload) throws (1: P13ServiceException p13ServiceException),
  i32 saveProfileProperties(list<ProfilePropertyValue> profilePropertyValues) throws (1: P13ServiceException p13ServiceException),
  string command(string command) throws (1: P13ServiceException p13ServiceException),
  BatchChoiceResponse batchChoose(BatchChoiceRequest batchChoiceRequest) throws (1: P13ServiceException p13ServiceException)
}