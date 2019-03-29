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
