module Zencoder
  # Zencoder::Result
  class Result
    def initialize(params)
      @params = params
    end

    def body
      @params
    end
  end

  # Zencoder::HTTPError
  class HTTPError
    def initialize(message = 'Fake Zencoder forced Exception')
      @message = message
    end

    def message
      @message
    end
  end

  class Job
    # Public: Return a new Zencoder::Result
    #
    # params: Hash of params
    #   1 - Success
    #   2 - Failure
    #   other - raise a new Zencoder::HTTPError
    #
    # Returns a job id
    def self.create(params)
      if params == 1
        Result.new({ 'id' => 1 })
      elsif params == 2
        Result.new({ 'error' => 'Fake Zencoder forced failer' })
      else
        raise HTTPError.new
      end
    end

    # Public: Return a new Zencoder::Result
    #
    # job_id: An Integer to be checked
    #   1 - 'finished'
    #   2 - 'failure'
    #   3 - 'processing'
    #   other - raise a new Zencoder::HTTPError
    def self.details(job_id)
      if job_id == 1
        Result.new({ 'job' => { 'state' => 'finished' } })
      elsif job_id == 2
        Result.new({ 'job' => { 'state' => 'failed', 'output_media_files' => [ { 'error_message' => 'Fake Zencoder forced failure' } ] } })
      elsif job_id == 3
        Result.new({ 'job' => { 'state' => 'processing' } })
      else
        raise HTTPError.new
      end
    end
  end

end
