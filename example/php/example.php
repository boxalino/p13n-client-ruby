<?php

require_once __DIR__ . DIRECTORY_SEPARATOR . 'Thrift' . DIRECTORY_SEPARATOR . 'HttpP13n.php';

$p13nHost     = 'c1.bx-cloud.com';
$p13nAccount  = 'example-account';
$p13nUsername = 'example-username';
$p13nPassword = 'example-password';

$p13nSearch   = 'example search query';
$p13nChoiceId = 'test-search';
$p13nLanguage = 'en'; // or de, fr, it, etc.
$p13nFields   = array('id'); // fields you want in the response, i.e. title, body, etc.
$p13nOffset   = 0;
$p13nHitCount = 25;

// Create basic P13n client
$p13n = new HttpP13n();
$p13n->setHost($p13nHost);
$p13n->setAuthorization($p13nUsername, $p13nPassword);

// Create main choice request object
$choiceRequest = $p13n->getChoiceRequest($p13nAccount);

// Setup main choice inquiry object
$inquiry = new \com\boxalino\p13n\api\thrift\ChoiceInquiry();
$inquiry->choiceId = $p13nChoiceId;

// Setup a search query
$searchQuery = new \com\boxalino\p13n\api\thrift\SimpleSearchQuery();
$searchQuery->indexId = $p13nAccount;
$searchQuery->language = $p13nLanguage;
$searchQuery->returnFields = $p13nFields;
$searchQuery->offset = $p13nOffset;
$searchQuery->hitCount = $p13nHitCount;
$searchQuery->queryText = $p13nSearch;

// Connect search query to the inquiry
$inquiry->simpleSearchQuery = $searchQuery;

// Add inquiry to choice request
$choiceRequest->inquiries = array($inquiry);

// Call the service
$choiceResponse = $p13n->choose($choiceRequest);

$results = array();
/** @var \com\boxalino\p13n\api\thrift\Variant $variant */
foreach ($choiceResponse->variants as $variant) {
	/** @var \com\boxalino\p13n\api\thrift\SearchResult $searchResult */
	$searchResult = $variant->searchResult;
	foreach ($searchResult->hits as $item) {
		$result = array();
		foreach ($item->values as $key => $value) {
			if (is_array($value) && count($value) == 1) {
				$result[$key] = array_shift($value);
			} else {
				$result[$key] = $value;
			}
		}
		// Widget's meta data, mostly used for event tracking
		$result['_widgetTitle'] = $variant->searchResultTitle;
		$results[] = $result;
	}
}

// Outputting the results
if (empty($results)): ?>
	<div>No results</div>
<?php else: ?>
	<div class="results">
	<?php foreach ($results as $result): ?>
		<div class="result"><?php echo htmlspecialchars($result['id'], ENT_COMPAT, 'UTF-8') ?></div>
	<?php endforeach; ?>
	</div>
<?php endif; ?>
