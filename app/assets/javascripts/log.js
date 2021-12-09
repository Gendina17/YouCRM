function send_client_mail() {
    document.getElementById('menu_text40').innerText = 'Отправляется'
    var subject = document.forms.mailForm.subject.value;
    var body = document.forms.mailForm.body.value;
    var token = document.forms.mailForm.authenticity_token.value;
    var id = document.forms.mailForm.id.value;

    params = 'subject=' + encodeURIComponent(subject) +
        '&body=' + encodeURIComponent(body) +
        '&id=' + encodeURIComponent(id) +
        '&authenticity_token=' + encodeURIComponent(token);

    var xhr = new XMLHttpRequest();
    xhr.open("GET", "/send_client_mail.json?" + params);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    xhr.onreadystatechange = function (){
        if (xhr.readyState == 4 && xhr.status == 200) {
            data = JSON.parse(xhr.responseText)
            document.getElementById('block_show_emails').innerHTML += `<article class="msg-container msg-self"><div class="msg-box"><div class="flr"><div class="messages"><p>${data[0]}</p><p class="msg" id="msg-1">${data[1]}</p></div><span class="timestamp"><span class="username">${data[2]}</span>&bull;<span class="posttime"> ${data[3]} </span></span></div></div></article>`;
            document.getElementById('menu_text40').innerText = 'Доставлено'
            setTimeout(document.getElementById('menu_text40').innerText = 'Отправить', 2000)
            document.forms.mailForm.body.value = ''
            document.forms.mailForm.subject.value = ''
            document.getElementById("block_show_emails").scrollTo(1000,30000000000000);
        }
    }
    xhr.send()
}

function show_emails(ticket_id){
    params = 'id=' + encodeURIComponent(ticket_id);

    var xhr = new XMLHttpRequest();
    xhr.open("GET", "/show_emails.json?" + params);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    xhr.onreadystatechange = function (){
        if (xhr.readyState == 4 && xhr.status == 200) {
            data = JSON.parse(xhr.responseText);
            document.getElementById('block_show_emails').innerHTML = ''
            if (data['key_present']) {
                emails = data['emails']
                for (i=0; i<emails.length; i++) {
                    if (emails[i][4]) {
                        document.getElementById('block_show_emails').innerHTML += `<article class="msg-container msg-remote"><div class="msg-box"><div class="flr"><div class="messages"><p>${emails[i][0]}</p><p class="msg" id="msg-1">${emails[i][1]}</p></div><span class="timestamp"><span class="username">${emails[i][2] == null ? '' : emails[i][2]}</span>&bull;<span class="posttime"> ${emails[i][3]} </span></span></div></div></article>`;
                    } else {
                        document.getElementById('block_show_emails').innerHTML += `<article class="msg-container msg-self"><div class="msg-box"><div class="flr"><div class="messages"><p>${emails[i][0]}</p><p class="msg" id="msg-1">${emails[i][1]}</p></div><span class="timestamp"><span class="username">${emails[i][2] == null ? '' : emails[i][2]}</span>&bull;<span class="posttime"> ${emails[i][3]} </span></span></div></div></article>`;
                    }
                }
            } else {
                document.getElementById('block_show_emails').innerHTML = 'С данным пользователем пока нет переписки'
            }

            if (data['key_sent']) {
                document.getElementById('input_email_for_id').value = ticket_id;
            } else {
                document.getElementById('block_send_email').innerHTML = data['message']
            }
            document.getElementById("block_show_emails").scrollTo(1000,30000000000000);
        }
    }
    xhr.send()
}

function create_note() {
    var body_ = document.forms.noteForm.body.value;
    var id = document.forms.noteForm.id.value;
    var token = document.forms.noteForm.authenticity_token.value

    var xhr = new XMLHttpRequest();

    xhr.open("POST", "/create_note")
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    body = 'body=' + encodeURIComponent(body_) +
        '&ticket_id=' + encodeURIComponent(id) +
        '&authenticity_token=' + encodeURIComponent(token);

    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4 && xhr.status == 200) {
            data = JSON.parse(xhr.responseText)
            current_value = document.getElementById('notes2').innerHTML

            document.getElementById('notes2'). innerHTML =  (`<li id="note_${data.id}"><p contenteditable="true" id_ticket='${data.id}' name='body' type_object='note'>${data.body}</p><span onclick="delete_note('${data.id}')" style="cursor: pointer"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-x-circle" viewBox="0 0 16 16">` +
                `<path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>` +
                `<path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/></svg></span><span class="note_manager">Вы</span></li>`);
            document.getElementById('notes2'). innerHTML += current_value
            document.forms.noteForm.body.value = ''
        }
    }
    xhr.send(body)
    return false;
}

function delete_note(id) {
    if (!confirm("Вы уверены что хотите удалить Заметку? Это необратимый процесс.")) {
        return
    } else {
        var xhr = new XMLHttpRequest();
        var params = 'id=' + encodeURIComponent(id);
        xhr.open("GET", "/delete_note?" + params)

        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4 && xhr.status == 200) {
            }
        }
        xhr.send()
        document.getElementById(`note_${id}`).style.display = 'none'
    }
}
function set_focus(el) {
    for(i=1; i<3; i++){
        document.getElementById(`bb_${i}`).classList.remove("i_active");
    }
    el.classList.add("i_active");
    if (el.id == 'bb_1') {
        document.getElementById('notes').classList.add('hidden');
        document.getElementById('logs').classList.remove('hidden');
    } else {
        document.getElementById('logs').classList.add('hidden');
        document.getElementById('notes').classList.remove('hidden');
    }
}
