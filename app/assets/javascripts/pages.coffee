$(document).on 'turbolinks:load', ->
  $('#new_task').on 'submit', (e) ->
    e.preventDefault()
    $.ajax '/tasks',
      type: 'POST'
      dataType: 'json',
      data: $("#new_task").serialize()
      success: (data, text, jqXHR) ->
        $('.msg').html('<div class="alert alert-success">' + 'Tarefa cadastrada com sucesso!' + '</div>').fadeIn()
        $('#task_description').val('')
        task = '<tr> <td>'+data['id']+'</td> <td> '+data['description']+' <br> </td> <td>Iniciar</td> <td>concluir tarefa </td> </tr>'

        $('.tasks').append(task)
      error: (jqXHR, textStatus, errorThrown) ->
        $('.msg').html('<div class="alert alert-danger">' + jqXHR.responseJSON[0] + '</div>').fadeIn()

  $('[data=add-pomodoro]').on 'click', (e) ->
    e.preventDefault
    $.ajax '/pomodoros',
      type: 'POST'
      dataType: 'json',
      data: $(this).serialize()
      success: (data, text, jqXHR) ->
        tomato = '<span class="tomato canceled"></span>'
        tomatos = '.tomatos_' + data['task_id']
        $(tomatos).append(tomato)
      error: (jqXHR, textStatus, errorThrown) ->
        $('.msg').html('<div class="alert alert-danger">' + 'Erro ao iniciar pomodoro' + '</div>').fadeIn()
    return false
