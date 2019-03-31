$(document).on 'turbolinks:load', ->
  $('#new_task').on 'submit', (e) ->
    e.preventDefault()
    $.ajax '/tasks',
      type: 'POST'
      dataType: 'json',
      data: $("#new_task").serialize()
      success: (data, text, jqXHR) ->
        $('.msg').html('<div class="alert alert-success">' + 'Tarefa cadastrada com sucesso!' + '</div>').fadeIn()
        id = data['id']
        description = data['description']

        task = '<tr>'+
                  '<td>'+id+'</td>'+
                  '<td class="tomatos_'+id+'"> '+data['description']+' <br> </td>'+
                  '<td> <button class="btn btn-warning" disabled="">fazendo</button> </td>'+
                  '<td> '+
                    '<form class="new_pomodoro" id="new_pomodoro" data="add-pomodoro_'+id+'" action="/pomodoros" method="post"> '+
                      '<input name="utf8" type="hidden" value="✓">'+
                      '<input type="hidden" name="authenticity_token" value="JORxoLeBNg5Banpig8Ezoyr/ezwTz3yuvoF3XBBgjbdf+OY9RutqLzmDBry0z+qP3cuueD9HXUZ7D69BeD71rA==">' +
                      '<input value="'+id+'" type="hidden" name="task_id" id="pomodoro_task_id"> '+
                      '<input value="2019-03-30 16:01:16 +0000" type="hidden" name="date" id="pomodoro_date">'+
                      '<input value="canceled" type="hidden" name="status" id="pomodoro_status">'+
                      '<input type="submit" name="commit" value="Iniciar" class="btn btn-primary" data-disable-with="Iniciar">'+
                    '</form>'+
                    '</td> '+
                    '<td> '+
                      '<form class="edit_task" id="edit_task_'+id+'" data="task_done" action="/tasks/'+id+'" method="post">'+
                        '<input name="utf8" type="hidden" value="✓">'+
                        '<input type="hidden" name="_method" value="patch">'+
                        '<input type="hidden" name="authenticity_token" value="q0qRHGKtArOPn9k6P+WR+uuti5XJa9M6/NNP/VRiqajQVgaBk8dekvd2peQI60jWHJle0eXj8tI5XZfgPDzRsw==">'+
                        '<input value="'+id+'" type="hidden" name="task[id]" id="task_id">'+
                        '<input value="1" type="hidden" name="task[status]" id="task_status">'+
                        '<input type="submit" name="commit" value="concluir tarefa" class="btn btn-success" data-disable-with="concluir tarefa">'+
                      '</form>'+
                    '</td>'+
                    '<td>'+
                      '<a href="/tasks/'+id+'/edit">editar</a> '+
                      '<a data-confirm="Você quer realmente deletar esta tarefa?" rel="nofollow" data-method="delete" href="/tasks/'+id+'">deletar</a>'+
                    '</td>'+
                '</tr>'

        $('.tasks').append(task)

        $('#task_description').val('')

        form_append_event_start_pomodoro = '[data=add-pomodoro_'+id+']'
        $(form_append_event_start_pomodoro).on 'click', (e) ->
          e.preventDefault
          date = data['date']
          $.ajax '/pomodoros',
            type: 'POST'
            dataType: 'json',
            data: {pomodoro: {"task_id": id, "date":date, "status":"canceled"}}
            success: (data, text, jqXHR) ->
              tomato = '<span class="tomato canceled"></span>'
              tomatos = '.tomatos_' + data['task_id']
              $(tomatos).append(tomato)
            error: (jqXHR, textStatus, errorThrown) ->
              $('.msg').html('<div class="alert alert-danger">' + 'Erro ao iniciar pomodoro' + '</div>').fadeIn()
          return false
      error: (jqXHR, textStatus, errorThrown) ->
        $('.msg').html('<div class="alert alert-danger">' + jqXHR.responseJSON[0] + '</div>').fadeIn()
    return false

  $('[data=add-pomodoro]').on 'click', (e) ->
    e.preventDefault
    $.ajax '/pomodoros',
      type: 'POST'
      dataType: 'json',
      data: $(this).serialize()
      success: (data, text, jqXHR) ->
        tomato = '<span class="tomato canceled"></span>'
        tomatos = '.tomatos_' + data['task_id']
        pomodoro_id =  data
        $(tomatos).append(tomato)
        minutes = 0
        seconds = 2
        start_timer(seconds,minutes, seconds,pomodoro_id)

      error: (jqXHR, textStatus, errorThrown) ->
        $('.msg').html('<div class="alert alert-danger">' + 'Erro ao iniciar pomodoro' + '</div>').fadeIn()
    return false

  $('body').on 'click', '[data=task_done]', (e) ->
    e.preventDefault
    id = $(this)[0][3].value
    task_removed = $(this).parent().parent()
    $.ajax '/tasks/' + id,
      type: 'PUT'
      dataType: 'json',
      data: $(this).serialize()
      success: (data, text, jqXHR) ->
        task_removed.remove()
        pomodoros = data.pomodoros.map((p) ->
          '<span class="tomato ' + p.status + '"></span>'
        )
        task = '<tr> <td>'+data['id']+'</td> <td>'+data['description']+'<br>'+pomodoros.join('')+'</td> </tr>'
        $('.tasks_done').append(task)
      error: (jqXHR, textStatus, errorThrown) ->
        $('.msg').html('<div class="alert alert-danger">' + 'Erro ao concluir tarefa' + '</div>').fadeIn()
    return false

  $('[data-js="start"]').on 'click', (e) ->
    minutes = 2
    seconds = 5
    alert('clique no iniciar da tarefa')
    # start_timer(seconds,minutes, seconds)

start_timer = (counter_seconds, counter_minutes, seconds_default, pomodoro_id) ->
  minutes = $('.minutes')
  seconds = $('.seconds')
  seconds_default = seconds_default
  seconds.text('0'+counter_seconds)
  minutes.text('0'+counter_minutes)

  if counter_seconds >= 0 && counter_minutes > -1
    timer = setTimeout (->
      seconds.text('0'+counter_seconds--)
      console.log counter_minutes + ':' + counter_seconds

      start_timer counter_seconds, counter_minutes, seconds_default, pomodoro_id
      return
    ), 1000

  if counter_seconds < 0
    counter_seconds = seconds_default
    counter_minutes--
    start_timer counter_seconds, counter_minutes, seconds_default, pomodoro_id
    return

  if counter_minutes < 0
    seconds.text('00')
    minutes.text('00')
    clearTimeout(timer);
    alert('O seu pomodoro terminou!')
    console.log 'stop'
    update_pomodoro(pomodoro_id['id'])

  return

update_pomodoro = (pomodoro_id) ->
  $.ajax '/pomodoros/' + pomodoro_id,
    type: 'PUT'
    dataType: 'json'
    data: pomodoro:
      id: pomodoro_id
      status: 'finished'
    success: (data, text, jqXHR) ->
      console.log 'update'
      location.reload()
      return
    error: (jqXHR, textStatus, errorThrown) ->
      console.log 'error update pomodoro'
      return
  return
