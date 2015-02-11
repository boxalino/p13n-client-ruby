namespace java com.boxalino.p13n.api.thrift
namespace php  com.boxalino.p13n.api.thrift

/**
 * Filter to be used in query. Note that type of generated filter depends on first non-null and non-empty value in order of preference. Values of lower priority are ignored:
 * stringValues!=null && simpleValues.size()>0 => simple match, prefix!=null => prefix match, hierarchy!=null && hierarchy.size()>0 => hierarchy filter, else range filter
 *
 * <dl>
 * <dt>negative</dt>
 * <dd>whether the filter is negative (boolean NOT)</dd>
 *
 * <dt>fieldName</dt>
 * <dd>field name to apply filter to</dd>
 *
 * <dt>stringValues</dt>
 * <dd>values for simple match</dd>
 *
 * <dt>prefix</dt>
 * <dd>prefix match</dd>
 *
 * <dt>hierarchyId</dt>
 * <dd>hierarchy filter - when corresponding hierarchical field has encoded id</dd>
 *
 * <dt>hierarchy</dt>
 * <dd>hierarchy filter - for example categories path in top-down order</dd>
 *
 * <dt>rangeFrom</dt>
 * <dd>lower bound for range filter</dd>
 *
 * <dt>rangeFromInclusive</dt>
 * <dd>whether the lower bound is inclusive</dd>
 *
 * <dt>rangeTo</dt>
 * <dd>upper bound for range filter</dd>
 *
 * <dt>rangeToInclusive</dt>
 * <dd>whether the upper bound is inclusive</dd>
 * </dl>
 */
struct Filter {
  1: bool negative,
  2: string fieldName,
  3: list<string> stringValues,
  4: string prefix,
  41: string hierarchyId,
  5: list<string> hierarchy,
  6: string rangeFrom,
  7: bool rangeFromInclusive,
  8: string rangeTo,
  9: bool rangeToInclusive
}

/**
 * Used for date facets
 */
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

/**
 * Whether facets should be order by population descending or by collation
 */
enum FacetSortOrder {
  POPULATION = 1,
  COLLATION = 2
}

/**
 * <dl>
 * <dt>stringValue</dt>
 * <dd>corresponding value of the facet</dd>
 *
 * <dt>rangeFromInclusive</dt>
 * <dd>if range facets lower bound (inclusive)</dd>
 *
 * <dt>rangeToExclusive</dt>
 * <dd>if range facets upper bound (inclusive)</dd>
 *
 * <dt>hitCount</dt>
 * <dd>number of hits found</dd>
 *
 * <dt>hierarchyId</dt>
 * <dd>id of hierarchy if corresponding field is hierarchical</dd>
 *
 * <dt>hierarchy</dt>
 * <dd>hierarchy if corresponding field is hierarchical</dd>
 *
 * <dt>selected</dt>
 * <dd>whether the facet value has been selected in corresponding FacetRequest</dd>
 * </dl>
 */
struct FacetValue {
  1: string stringValue,
  2: string rangeFromInclusive,
  3: string rangeToExclusive,
  4: i64 hitCount,
  50: string hierarchyId,
  60: list<string> hierarchy,
  70: bool selected
}

/**
 * <dl>
 * <dt>fieldName</dt>
 * <dd>name of the field to get facet for</dd>
 *
 * <dt>numerical</dt>
 * <dd>whether the facet is numerical</dd>
 *
 * <dt>range</dt>
 * <dd>whether the facet is range facet</dd>
 *
 * <dt>maxCount</dt>
 * <dd>maximum number of facets to return by given order, -1 for all of them</dd>
 *
 * <dt>minPopulation</dt>
 * <dd>minimum facet population to return</dd>
 *
 * <dt>dateRangeGap</dt>
 * <dd>if the corresponding field is date then the gap to be used for facet</dd>
 *
 * <dt>sortOrder</dt>
 * <dd>sort order</dd>
 *
 * <dt>sortAscending</dt>
 * <dd>whether the sort should be done ascending</dd>
 *
 * <dt>selectedValues</dt>
 * <dd>values selected from the facet.</dd>
 * <dd>Note that results will be filtered by these values, but the corresponding
 * FacetResponse is as if this filter was not applied</dd>
 *
 * <dt>andSelectedValues</dt>
 * <dd>whether selectedValues should be considered in AND logic, meaning filter
 * out those that don't contain ALL selected values - default is OR - include
 * those contianing any of selectedValue</dd>
 * </dl>
 */
struct FacetRequest {
  1: string fieldName,
  2: bool numerical,
  3: bool range,
  4: i32 maxCount = -1,
  5: i32 minPopulation = 1,
  6: DateRangeGap dateRangeGap,
  7: FacetSortOrder sortOrder,
  8: bool sortAscending,
  90: list<FacetValue> selectedValues,
  100: bool andSelectedValues = false
}

/**
 * field to be used for sorting
 */
struct SortField {
  1: string fieldName,
  2: bool reverse
}

/**
 * <dl>
 * <dt>indexId</dt>
 * <dd>indexId to be used for search</dd>
 *
 * <dt>language</dt>
 * <dd>language for localization</dd>
 *
 * <dt>queryText</dt>
 * <dd>main search query</dd>
 *
 * <dt>filters</dt>
 * <dd>list of filters to apply</dd>
 *
 * <dt>orFilters</dt>
 * <dd>whether boolean OR should be aplied to the given list of filters if false
 * boolean AND will be applied</dd>
 *
 * <dt>facetRequests</dt>
 * <dd>list of facets to be returned</dd>
 *
 * <dt>sortFields</dt>
 * <dd>optional list of sort fields for hardcoded sorting. If not given,
 * relevance sort order will be used</dd>
 *
 * <dt>offset</dt>
 * <dd>from which hit to return result</dd>
 *
 * <dt>hitCount</dt>
 * <dd>how many hits to return</dd>
 *
 * <dt>returnFields</dt>
 * <dd>which index fields to be returned</dd>
 *
 * <dt>groupBy</dt>
 * <dd>field name of the field to do grouping by</dd>
 *
 * <dt>groupFacets</dt>
 * <dd>whether facets counts should contain number of groups</dd>
 *
 * <dt>groupItemsCount</dt>
 * <dd>how many hits in each group to return</dd>
 *
 * <dt>groupItemsSort</dt>
 * <dd>how to sort items within the group, default is score</dd>
 *
 * <dt>groupItemsSortAscending</dt>
 * <dd>whether to sort items within the group ascending</dd>
 * </dl>
 */
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
 10: list<string> returnFields,
 20: string groupBy,
 30: bool groupFacets = true,
 40: i32 groupItemsCount = 1,
 50: string groupItemsSort = "score",
 60: bool groupItemsSortAscending = false
}

/**
 * <dl>
 * <dt>indexId</dt>
 * <dd>id of the index to fetch context item data from</dd>
 *
 * <dt>fieldName</dt>
 * <dd>the field name of the item's unique identifier within the items index</dd>
 * <dd>for example: 'sku' for items 'products'</dd>
 *
 * <dt>contextItemId</dt>
 * <dd>actual item's identifier</dd>
 * <dd>for example: actual sku of the product</dd>
 *
 * <dt>role</dt>
 * <dd>role of the item within the context, used to address the item in the
 * recommendation script.</dd>
 * <dd>for example: 'main product' for recommendations within product detail
 * page</dd>
 * </dl>
 */
struct ContextItem {
  1: string indexId,
  2: string fieldName,
  3: string contextItemId,
  4: string role
}

/**
 * <dl>
 * <dt>choiceId</dt>
 * <dd>personalization choice identificator</dd>
 *
 * <dt>simpleSearchQuery</dt>
 * <dd>search query in a case of recommendation and search inquiries</dd>
 *
 * <dt>contextItems</dt>
 * <dd>context items for recommendations</dd>
 *
 * <dt>minHitCount</dt>
 * <dd>minimal hit count to return for recommendations.</dd>
 * <dd>if higher priority recommendation strategy yields less results, next
 * strategy is tried</dd>
 *
 * <dt>excludeVariantIds</dt>
 * <dd>set of variantIds to be excluded from result</dd>
 *
 * <dt>scope</dt>
 * <dd>choice source to be used</dd>
 *
 * <dt>withRelaxation</dt>
 * <dd>if search relaxation should be used</dd>
 * </dl>
 */
struct ChoiceInquiry {
  1: string choiceId,
  2: SimpleSearchQuery simpleSearchQuery,
  3: list<ContextItem> contextItems,
  4: i32 minHitCount,
  5: set<string> excludeVariantIds,
  6: string scope = "system_rec",
  70: bool withRelaxation = false,
  80: bool withSemanticFiltering = false
}

/**
 * parameters of request context. Usually browser, platform, etc.
 */
struct RequestContext {
  1: map<string,list<string>> parameters
}

/**
 * unique identifier of the customer
 */
struct UserRecord {
  1: string username
}

/**
 * <dl>
 * <dt>profileId</dt>
 * <dd>profile (visitor) identificator</dd>
 *
 * <dt>inquiries</dt>
 * <dd>list of inquiries to be executed sequentially.</dd>
 * <dd>Inquiries with higher index may depend from those with lower index.</dd>
 *
 * <dt>requestContext</dt>
 * <dd>context of the request</dd>
 * </dl>
 */
struct ChoiceRequest {
  1: UserRecord userRecord,
  2: string profileId,
  3: list<ChoiceInquiry> inquiries,
  4: RequestContext requestContext
}

/**
 * <dl>
 * <dt>fieldName</dt>
 * <dd>name of the facet field</dd>
 *
 * <dt>values</dt>
 * <dd>list of facet values</dd>
 * </dl>
 */
struct FacetResponse {
  1: string fieldName,
  2: list<FacetValue> values
}

/**
 * item found
 *
 * <dl>
 * <dt>values</dt>
 * <dd>map containing name of the field and list of values as strings</dd>
 * <dd>if index contains no value for a field, empty array will be returned.</dd>
 *
 * <dt>score</dt>
 * <dd>index score of the hit</dd>
 *
 * <dt>scenarioId</dt>
 * <dd>source scenarioId in case of mixed recommendations modes</dd>
 * </dl>
 */
struct Hit {
  1: map<string, list<string>> values,
  2: double score,
 30: string scenarioId
}

/**
 * grouped item found
 *
 * <dl>
 * <dt>groupValue</dt>
 * <dd>value of the groupBy field</dd>
 *
 * <dt>totalHitCount</dt>
 * <dd>total hits count within the group</dd>
 *
 * <dt>hits</dt>
 * <dd>group hits</dd>
 * </dl>
 */
struct HitsGroup {
  10: string groupValue,
  20: i64 totalHitCount,
  30: list<Hit> hits
}

/**
 * <dl>
 * <dt>hits</dt>
 * <dd>list of hits found for given SimpleSearchQuery</dd>
 *
 * <dt>facetResponses</dt>
 * <dd>list of requested facets or null if none requested</dd>
 *
 * <dt>totalHitCount</dt>
 * <dd>total number of hits; -1 in case of mixed recommendation strategy</dd>
 *
 * <dt>queryText</dt>
 * <dd>relaxation query text for relaxation results or requested queryText for a
 * regular SearchResult</dd>
 *
 * <dt>hitsGroups</dt>
 * <dd>grouped hits; not null when corresponding SimplSearchQuery has
 * groupBy!=null </dd>
 * </dl>
 */
struct SearchResult {
  1: list<Hit> hits,
  2: list<FacetResponse> facetResponses,
  3: i64 totalHitCount,
  40: string queryText,
  50: list<HitsGroup> hitsGroups
}

struct SearchRelaxation {
  10: list<SearchResult> suggestionsResults,
  20: list<SearchResult> subphrasesResults
}

/**
 * <dl>
 * <dt>variantId</dt>
 * <dd>id of the personalized variant</dd>
 *
 * <dt>scenarioId</dt>
 * <dd>scenario identificator used to produce recommendation result or search
 * result personalization</dd>
 *
 * <dt>searchResult</dt>
 * <dd>result of the search request for recommendations and search requests</dd>
 *
 * <dt>searchResultTitle</dt>
 * <dd>recommendation's result title localized in language requested in
 * corresponding SimpleSearchQuery</dd>
 *
 * <dt>searchRelaxation</dt>
 * <dd>When the service considers queryText invalid, it will evaluate and return
 * relaxations if it is requested in corresponding ChoiceInquiry and if
 * relaxations could be found.</dd>
 * <dd>Note that original query still could yield some results; it is up to the
 * client to decide whether searchRelaxations should be used (with displaying
 * appropriate message) or not.</dd>
 * </dl>
 */
struct Variant {
  1: string variantId,
  2: string scenarioId,
  3: SearchResult searchResult,
  4: string searchResultTitle,
  50: SearchRelaxation searchRelaxation,
  60: list<SearchResult> semanticFilteringResults
}

/**
 * list of personalized variants. Item's index corresponds to the index of the
 * ChoiceInquiry
 */
struct ChoiceResponse {
  1: list<Variant> variants
}

struct ProfilePropertyValue {
  1: string profileId,
  2: string propertyName,
  3: string propertyValue, 
  4: i32 confidence
}

/**
 * <dl>
 * <dt>choiceInquiry</dt>
 * <dd><b>deprecated</b> - use choiceInquiries instead.</dd>
 * <dd>If choiceInquiries is given this field will be ignored</dd>
 *
 * <dt>choiceInquiries</dt>
 * <dd>list of ChoiceInquiries to be executed sequentially.</dd>
 * <dd>Note that list items can depend of items before in list</dd>
 * </dl>
 */
struct BatchChoiceRequest {
  1: UserRecord userRecord,
  2: ChoiceInquiry choiceInquiry,
  3: RequestContext requestContext,
  4: list<string> profileIds,
  5: list<ChoiceInquiry> choiceInquiries
}

/**
 * <dl>
 * <dt>variants</dt>
 * <dd><b>deprecated</b> - contains non-null value only if
 * corresponding BatchChoiceRequest had only one ChoiceInquiry</dd>
 *
 * <dt>selectedVariants</dt>
 * <dd>outer list corresponds to profileIds given in BatchChoiceRequest, while
 * inner list corresponds to list of ChoiceInquiries from BatchChoiceRequest</dd>
 * </dl>
 */
struct BatchChoiceResponse {
  1: list<Variant> variants,
  2: list<list<Variant>> selectedVariants
}

struct AutocompleteHit {
    11: string suggestion,
    21: string highlighted,
    31: SearchResult searchResult,
    41: double score
}

struct AutocompleteQuery {
    11: string indexId,
    21: string language,
    31: string queryText,
    41: i32 suggestionsHitCount,
    51: bool highlight,
    61: string highlightPre = "<em>",
    71: string highlightPost = "</em>"
}

struct AutocompleteRequest {
    11: UserRecord userRecord,
    21: string scope = "system_rec",
    31: string choiceId,
    41: string profileId,
    51: RequestContext requestContext,
    61: set<string> excludeVariantIds,
    71: AutocompleteQuery autocompleteQuery,
    81: string searchChoiceId,
    91: SimpleSearchQuery searchQuery
}

struct AutocompleteResponse {
    11: list<AutocompleteHit> hits,
    21: SearchResult prefixSearchResult
}

/**
 * Request object for changing the choice, that is changing possible variants 
 * or their random distribution
 */
struct ChoiceUpdateRequest {
    /**
     * user record identifying the client
     */
    11: UserRecord userRecord,
    /**
     * Identifier of the choice to be changed. If it is not given, a new choice will be created 
     */
    21: string choiceId,
    /**
     * Map containing variant identifier and corresponding positive integer weight.
     * If for a choice there is no learned rule which can be applied, weights of 
     * variants will be used for variants random distribution.
     * Higher weight makes corresponding variant more probable.
     */
    31: map<string, i32> variantIds
}

 /**
  * Server response for one ChoiceUpdateRequest
  */
struct ChoiceUpdateResponse {
    /**
     * Identifier of the changed choice. If no id is given in corresponding 
     * ChoiceUpdateRequest, new choice (and new id) will be created and retuned.
     */
    11: string choiceId
}

exception P13nServiceException {
  1: required string message
}

service P13nService {
/**
 * <dl>
 * <dt>@param choiceRequest</dt>
 * <dd>the ChoiceRequest object containing your request</dd>
 *
 * <dt>@return</dt>
 * <dd>a ChoiceResponse object containing the list of variants</dd>
 *
 * <dt>@throws P13nServiceException</dt>
 * <dd>an exception containing an error message</dd>
 * </dl>
 */
  ChoiceResponse choose(ChoiceRequest choiceRequest) throws (1: P13nServiceException p13nServiceException),

/**
 * <dl>
 * <dt>@param batchChoiceRequest</dt>
 * <dd>the BatchChoiceRequest object containing your requests</dd>
 *
 * <dt>@return</dt>
 * <dd>a BatchChoiceResponse object containing the list of variants for each request</dd>
 *
 * <dt>@throws P13nServiceException</dt>
 * <dd>an exception containing an error message</dd>
 * </dl>
 */
  BatchChoiceResponse batchChoose(BatchChoiceRequest batchChoiceRequest) throws (1: P13nServiceException p13nServiceException),

/**
 * <dl>
 * <dt>@param request</dt>
 * <dd>the AutocompleteRequest object containing your request</dd>
 *
 * <dt>@return</dt>
 * <dd>a AutocompleteResponse object containing the list of hits</dd>
 *
 * <dt>@throws P13nServiceException</dt>
 * <dd>an exception containing an error message</dd>
 * </dl>
 */
  AutocompleteResponse autocomplete(AutocompleteRequest request) throws (1: P13nServiceException p13nServiceException)
  
/**
 * Updating a choice or creating a new choice if choiceId is not given in choiceUpdateRequest.
 */
  ChoiceUpdateResponse updateChoice(ChoiceUpdateRequest choiceUpdateRequest) throws (1: P13nServiceException p13nServiceException)
}
