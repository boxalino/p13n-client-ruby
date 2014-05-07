<?php

/**
 * Class P13n
 * @method \com\boxalino\p13n\api\thrift\ChoiceResponse choose(\com\boxalino\p13n\api\thrift\ChoiceRequest $choiceRequest)
 */
class HttpP13n
{
	protected static $thriftClassLoader = null;
	protected $dependencies = array(
		'../../../gen-php/com/boxalino/p13n/api/thrift/P13nService.php',
		'../../../gen-php/com/boxalino/p13n/api/thrift/Types.php',
	);
	protected $client = null;
	protected $transport = null;
	protected $host;
	protected $port = 443;
	protected $uri = '/p13n.web/p13n';
	protected $schema = 'https';
	protected $username;
	protected $password;

	/**
	 *
	 */
	public function __construct()
	{
		if (self::$thriftClassLoader === null) {
			$this->initClassLoader();
		}
	}

	public function __call($name, $arguments)
	{
		if (method_exists($this->getClient(), $name)) {
			return call_user_func_array(array($this->getClient(), $name), $arguments);
		} else {
			throw new Exception("Method $name not supported in P13nService");
		}
	}

	/**
	 * @param string $accountname
	 * @param string $cookieDomain
	 * @return string
	 */
	public function getChoiceRequest($accountname, $cookieDomain = null)
	{
		$choiceRequest = new \com\boxalino\p13n\api\thrift\ChoiceRequest();

		// Setup information about account
		$userRecord = new \com\boxalino\p13n\api\thrift\UserRecord();
		$userRecord->username = $accountname;
		$choiceRequest->userRecord = $userRecord;

		// Setup request context
		$clientip    = @$_SERVER['HTTP_CLIENT_IP'];
		$forwardedip = @$_SERVER['HTTP_X_FORWARDED_FOR'];
		if(filter_var($clientip, FILTER_VALIDATE_IP)) {
			$ip = $clientip;
		} elseif(filter_var($forwardedip, FILTER_VALIDATE_IP)) {
			$ip = $forwardedip;
		} else {
			$ip = @$_SERVER['REMOTE_ADDR'];
		}

		if(empty($_COOKIE['cems'])) {
			$sessionid = session_id();
			if(empty($sessionid)) {
				session_start();
				$sessionid = session_id();
			}
		} else {
			$sessionid = $_COOKIE['cems'];
		}

		if(empty($_COOKIE['cemv'])) {
			$profileid = '';
			if(function_exists('openssl_random_pseudo_bytes')) {
				$profileid = bin2hex(openssl_random_pseudo_bytes(16));
			}
			if(empty($profileid)) {
				$profileid = uniqid('', true);
			}
		} else {
			$profileid = $_COOKIE['cemv'];
		}

		$requestContext = new \com\boxalino\p13n\api\thrift\RequestContext();
		$requestContext->parameters = array(
			'User-Agent'     => @$_SERVER['HTTP_USER_AGENT'],
			'User-Host'      => $ip,
			'User-SessionId' => $sessionid,
			'User-Referer'   => @$_SERVER['HTTP_REFERER'],
		);
		$choiceRequest->RequestContext = $requestContext;
		$choiceRequest->profileId = $profileid;

		// Refresh cookies
		if(empty($cookieDomain)) {
			setcookie('cems', $sessionid, 0);
			setcookie('cemv', $profileid, time() + 1800);
		} else {
			setcookie('cems', $sessionid, 0, '/', $cookieDomain);
			setcookie('cemv', $profileid, time() + 1800, '/', $cookieDomain);
		}

		return $choiceRequest;
	}

	/**
	 * @return \com\boxalino\p13n\api\thrift\P13nServiceClient
	 */
	protected function getClient()
	{
		if ($this->client === null || $this->transport === null) {
			$this->transport = new \Thrift\Transport\P13nTHttpClient($this->host, $this->port, $this->uri, $this->schema);
			$this->transport->setAuthorization($this->username, $this->password);
			$this->client = new \com\boxalino\p13n\api\thrift\P13nServiceClient(new \Thrift\Protocol\TCompactProtocol($this->transport));
		}
		return $this->client;
	}

	/**
	 * @param string $username
	 * @param string $password
	 */
	public function setAuthorization($username, $password)
	{
		$this->username = $username;
		$this->password = $password;
		$this->transport = null;
	}

	/**
	 * @param string $host
	 */
	public function setHost($host)
	{
		$this->host = $host;
		$this->transport = null;
	}

	/**
	 * @param int $port
	 */
	public function setPort($port)
	{
		$this->port = $port;
		$this->transport = null;
	}

	/**
	 * @param string $schema
	 */
	public function setSchema($schema)
	{
		$this->schema = $schema;
		$this->transport = null;
	}

	/**
	 *
	 */
	protected function initClassLoader()
	{
		require_once __DIR__ . DIRECTORY_SEPARATOR . 'ClassLoader' . DIRECTORY_SEPARATOR . 'ThriftClassLoader.php';
		self::$thriftClassLoader = new \Thrift\ClassLoader\ThriftClassLoader(false);
		self::$thriftClassLoader->registerNamespace('Thrift', __DIR__ . DIRECTORY_SEPARATOR . '..');
		self::$thriftClassLoader->register();
		foreach ($this->dependencies as $dependency) {
			require_once __DIR__ . DIRECTORY_SEPARATOR . $dependency;
		}
	}
}
