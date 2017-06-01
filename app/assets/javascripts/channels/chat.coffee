jQuery(document).on 'turbolinks:load', ->
  $messages = $('#messages')
  $new_message_form = $('#new-message')
  $new_message_body = $new_message_form.find('#message-body')
  $new_message_attachment = $new_message_form.find('#message-attachment')

  if $messages.length > 0
    App.chat = App.cable.subscriptions.create {
        channel: "ChatChannel"
      },
      connected: ->

      disconnected: ->

      received: (data) ->
        if data['message']
          $new_message_body.val('')
          $messages.append data['message']

      send_message: (message, file_uri, original_name) ->
        @perform 'send_message', message: message, file_uri: file_uri, original_name: original_name

    $new_message_form.submit (e) ->
      $this = $(this)
      message_body = $new_message_body.val()

      if $.trim(message_body).length > 0 or $new_message_attachment.get(0).files.length > 0
        if $new_message_attachment.get(0).files.length > 0 # if file is chosen
          reader = new FileReader() # standart JS file reader
          file_name = $new_message_attachment.get(0).files[0].name
          reader.addEventListener "loadend", -> # when file has finished loading
            App.chat.send_message message_body, reader.result, file_name # send message with file
            # at this point reader.result is a BASE64-encoded file

          reader.readAsDataURL $new_message_attachment.get(0).files[0] # read file in base 64 format
        else
          App.chat.send_message message_body

      e.preventDefault()
      return false
