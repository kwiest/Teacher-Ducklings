# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def s3_uploader(options = {})
    bucket = ENV['S3_BUCKET']
    access_key = ENV['S3_KEY']
    secret_key = ENV['S3_SECRET']

    key = options[:key] || ''
    content_type = options[:content_type] || ''
    acl = options[:acl] || 'public-read'
    expiration_date = 10.hours.from_now.utc.strftime('%Y-%m-%dT%H:%M:%S.000Z')
    max_filesize = 500.megabyte
    file_ext = options[:file_ext] || '*.*'

    policy = Base64.encode64(
      "{'expiration': '#{expiration_date}',
        'conditions': [
          {'bucket': '#{bucket}'},
          ['starts-with', '$key', '#{key}'],
          {'acl': '#{acl}'},
          ['content-length-range', '0', '#{max_filesize}'],
          {'success_action_status': '201'},
          ['starts-with', '$folder', ''],
          ['starts-with', '$Filename', ''],
          ['starts-with', '$fileext', '']
        ]
      }").gsub(/\n|\r/, '')

    signature = Base64.encode64(
      OpenSSL::HMAC.digest(
        OpenSSL::Digest::Digest.new('sha1'),
        secret_key, policy
      )
    ).gsub("\n", "")

    out = ""
    #out << %(
      #<form action="https://#{bucket}.s3.amazonaws.com/" method="post" enctype="multipart/form-data" id="upload-form">
        #<input type="hidden" name="key" value="#{key}s/${filename}">
        #<input type="hidden" name="AWSAccessKeyId" value="#{access_key}">
        #<input type="hidden" name="acl" value="#{acl}">
        #<input type="hidden" name="policy" value="#{policy}">
        #<input type="hidden" name="signature" value="#{signature}">
        #<input type="hidden" name="success_action_status" value="201">

        #<input id="upload_#{options[:key]}" name="file" type="file">
    #)

    out << link_to("New #{key}", "#", :id => "upload_#{key}")
    out << %(
      <script type="text/javascript">
          $(function() {
              $('#upload_#{key}').uploadify({
                  'uploader'      : '/swf/uploadify.swf',
                  'script'        : "https://#{bucket}.s3.amazonaws.com",
                  'auto'          : 'true',
                  'multi'         : 'false',
                  'fileDataName'  : 'file',
                  'cancelImg'     : '/images/cancel.png',
                  'height'        : 40,
                  'width'         : 150,
                  'buttonImg'     : '#{options[:button_img]}',
                  'folder'        : '#{key}',
                  'fileExt'       : '#{file_ext}',
                  'scriptData'    : {
                    'key'                   : '#{key}s/${filename}',
                    'AWSAccessKeyId'        : '#{access_key}',
                    'acl'                   : '#{acl}',
                    'policy'                : encodeURIComponent('#{policy}'),
                    'signature'             : encodeURIComponent('#{signature}'),
                    'success_action_status' : '201',
                    'Content-Type'          : ''
                  },
                  'onComplete'    : function(event, queueID, fileObj, response, data){
                    var xml, fileName;
                    xml = $.parseXML(response);
                    fileName = $(xml).find("Key").text();
                    console.log(fileName);
                    $("#upload_#{key}Uploader").hide();
                    $("#video_video_file_name").val(fileName);
                    $("#new_#{key}").show();
                  },
                  'onError'       : function(event, id, fileObj, errorObj) {
                    console.log(event);
                    console.log(id);
                    console.log(fileObj);
                    console.log(errorObj);
                  }
              });
          })
      </script>
    )
  end
end
