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
	 * @return string
	 */
	public function getProfileId()
	{
		$profileId = null;
		if (!empty($_COOKIE['cemv'])) {
			$cemv = explode('|', $_COOKIE['cemv']);
			foreach ($cemv as $values) {
				$kvPair = explode('=', $values, 2);
				if (!empty($kvPair[0]) && !empty($kvPair[1]) && $kvPair[0] === 'r') {
					$profileId = $kvPair[1];
					break;
				}
			}
		}
		return $profileId;
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
