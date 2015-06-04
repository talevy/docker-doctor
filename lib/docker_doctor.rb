class DockerDoctor
  def initialize
    require 'docker'
    Docker.options = { :write_timeout => 300, :read_timeout => 300 }
    Docker.validate_version!
    @host = {
      :host_ip => get_host_ip,
      :ports => {}
    }
    @container = nil
    @image = nil
  end

  def get_host_ip
    # Let the crazy one-liner definition begin:
    # Docker.url.split(':')[1][2..-1]
    # Docker.url = tcp://192.168.123.205:2375
    #   split(':') = ["tcp", "//192.168.123.205", "2375"]
    #   [1] = "//192.168.123.205"
    #   [2..-1] = "192.168.123.205"
    # This last bit prunes the leading //
    url = Docker.url
    case url.split(':')[0]
    when 'unix'
      ip = "127.0.0.1"
    when 'tcp'
      ip = url.split(':')[1][2..-1]
    end
    ip
  end

  def provision(name, dockerfile_path)
    dockerfile = IO.read(dockerfile_path)
    @image = Docker::Image.build(dockerfile)
    @container = Docker::Container.create({
      'Image' => @image.id,
      'Hostname' => "#{name}-#{image.id}",
    })

    @container.start({"PublishAllPorts" => true})
    @host[:ports] = @container.json["NetworkSettings"]["Ports"]
  end

  def cleanup
    if @container
      @container.stop
      @container.delete
    end
    if @image
      @image.remove(:force => true)
    end
  end

  attr_reader :host
  attr_reader :container
  attr_reader :image
end

