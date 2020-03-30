require 'socket'

$stdout.sync = true

# @note port to listen on
@port = ARGV[0].to_i

# @note fail frequency = 1/flop
@flop = [ARGV[1].to_i, 1].max

puts "Starting server on port #{@port}..."
@server = TCPServer.new @port
@threads = []
@i = 0

def accept!
    sock = @server.accept
    @i += 1
    sock
end

def should_flop?
    @i % @flop > 0
end

def log(msg)
    entry = "[#{@port}:#{@i}] #{msg}"
    puts entry
    entry
end

begin
    while session = accept!
        log "connection open"

        if should_flop?
            log "flopping..."
            # @note nop => read timeout
            # @note session.close => connection closed
            # @note @server.close => connection timeout
            next
        end

        @threads << Thread.new(session) do |session|
            log "responding..."
            begin
                body = log("Hello world! The time is #{Time.now}")

                session.print "HTTP/1.1 200 OK\r\n"
                session.print "Content-Length: #{body.bytesize}\r\n"
                session.print "Content-Type: text/plain\r\n"
                session.print "Connection: close\r\n"
                session.print "\r\n"
                session.print body
            rescue => e
                puts e.inspect
                raise e
            ensure
                session.close
            end
        end
    end

ensure
    log "Draining connections..."
    @threads.each(&:join)
end

log "Server terminated."
