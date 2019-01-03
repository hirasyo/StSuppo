$ ->
  $monster_table_default = $('.monster_table_default')

  $(document)
  .on 'ajax:complete', (event) ->
    response = event.detail[0].response
    $('#updated_by_ajax').html(response)
    $monster_table_default.addClass("hidden")
