class Version
  attr_accessor :minor, :major, :build

  def initialize(major, minor, build)
    # assign instance avriables
    @major, @minor, @build = major, minor, build
  end

  def self.parse(parsed)
    #TODO: впилить проверку на правильный формат
    {'beta' => self.parse_beta(parsed), 'rc' => self.parse_rc(parsed), 'release' => self.parse_release(parsed)}
  end

  def to_s
    self.major.to_s + "." + self.minor.to_s + "." + self.build.to_s
  end

  def self.parse_beta(parsed)
    beta_version = parsed["beta"]
    self.parse_string(beta_version)
  end

  def self.parse_rc(parsed)
    rc_version = parsed["rc"]
    self.parse_string(rc_version)
  end

  def self.parse_release(parsed)
    release_version = parsed["release"]
    self.parse_string(release_version)
  end

  def self.parse_string(str)
    # puts('Parsing version str ' + str)
    v_elements = str.split(pattern='.')
    build_value = v_elements[1].split(pattern='(')[1].split(pattern=')')[0]
    Version.new(v_elements[0].to_i, v_elements[1].to_i, build_value.to_i)
  end

  def <= (other)
    if @major < other.major
      return true
    elsif @major == other.major && @minor < other.minor
      return true
    elsif @major == other.major && @minor == other.minor && @build < other.build
      return true
    elsif @major == other.major && @minor == other.minor && @build == other.build
      return true
    end
    false
  end

  def toString
    res = @major.to_s + '.' + @minor.to_s + '(' + @build.to_s + ')'
  end
end

class GSVersionValue
  #values stores like {'projectName': {'beta':Version, 'rc':Version, 'release': Version}}

  @@versions_dict = {}

  def self.versions_dict
    if @@versions_dict.length == 0
      GSVersionApiProvider.getVersions
      puts('Did update versions static variable')
    end
    @@versions_dict
  end

  #projectName string - project alias
  #build string - beta/rc/release
  #value Version object
  def updateValue(projectName, buildType, value)
    self.versions_dict[projectName][buildType] = value
  end

  def self.parseBackendResponse(body)
    puts(body.to_s)
    versions = {}
    body.each do |serverValue|
      project_alias = serverValue['alias']
      localValue = Version.parse({
                                     'beta' => serverValue['betaVersionName'],
                                     'rc' => serverValue['rcVersionName'],
                                     'release' => serverValue['releaseVersionName']
                                 })
      versions[project_alias] = localValue
    end
    @@versions_dict = versions
  end

  def self.getVersion(project_name)
    self.versions_dict[project_name]
  end
end

class GSVersionApiProvider
  @@client = Spaceship::GSBotClient.new

  def self.getVersions()
    url = 'versions?platform=ios'
    response = @@client.request(:get) do |req|
      req.url url
      req.headers['Content-Type'] = 'application/json'
    end

    if response.success?
      GSVersionValue.parseBackendResponse(response.body)
    else
      raise(@@client.class.hostname + url + ' ' + response.status.to_s + ' ' + response.body['message'])
    end
  end

  def self.updateVersions(projectName, newValue = GSVersionValue.versions_dict[projectName])
    require 'json'
    GSVersionValue.versions_dict[projectName] = newValue
    url = 'versions'
    json_params = {
        'alias' => projectName,
        'betaVersionName' => newValue['beta'],
        'rcVersionName' => newValue['rc'],
        'releaseVersionName' => newValue['release']
    }
    response = @@client.request(:patch) do |req|
      req.url url
      req.body = json_params.to_json
      req.headers['Content-Type'] = 'application/json'
    end

    if response.success?
      return response
    else
      raise(@@client.class.hostname + url + ' ' + response.status.to_s + ' ' + response.body['message'])
    end
  end
end