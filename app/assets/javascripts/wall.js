function send_wall_form(){

    var body = document.forms.wallForm.body.value;
    var token = document.forms.wallForm.authenticity_token.value;
    var tag = document.forms.wallForm.tag.value;


    var xhr = new XMLHttpRequest();
    xhr.open("POST", "/create_wall.json");
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    body = 'body=' + encodeURIComponent(body) +
        '&authenticity_token=' + encodeURIComponent(token) +
        '&tag=' + encodeURIComponent(tag);

    xhr.onreadystatechange = function (){
        if (xhr.readyState == 4 && xhr.status == 200) {
            document.getElementById('message_input').value = '';
            data = JSON.parse(xhr.responseText)
            document.getElementById("chat-window").innerHTML += `<article class="msg-container msg-self" id="msg-0"><div class="msg-box msg-${data[1]}">` +
                `<div class="flr"><div class="messages"><p class="msg" id="msg-1">${data[0]}</p></div>`+
                `<span class="timestamp"><span class="username">Вы</span>&bull;<span class="posttime"> ${data[2]} </span> &bull;` +
                `${data[3]}</span></div><img class="user-img" id="user-0" src="${data[4]}" /></div></article>`;
            document.getElementById("chat-window").scrollTo(0,30000000000000);
        }
    }
    xhr.send(body)
}

function show_walls(){
    if (document.getElementById('notification')){
        document.getElementById('notification').classList.add('hidden');
    }

    var xhr = new XMLHttpRequest();
    xhr.open("GET", "/all_walls.json");

    xhr.onreadystatechange = function (){
        if (xhr.readyState == 4 && xhr.status == 200) {
            data = JSON.parse(xhr.responseText)
            data.forEach(function(item, i, arr) {
                if (item[5] == '1') {
                    document.getElementById("chat-window").innerHTML += `<article class="msg-container msg-self" id="msg-0"><div class="msg-box msg-${item[1]}">` +
                        `<div class="flr"><div class="messages"><p class="msg" id="msg-1">${item[0]}</p></div>`+
                        `<span class="timestamp"><span class="username">Вы</span>&bull;<span class="posttime"> ${item[2]} </span> &bull;` +
                        `${item[3]}</span></div><img class="user-img" id="user-0" src="${item[4]}"/>${item[6]}</div></article>`;
                } else {
                    document.getElementById("chat-window").innerHTML += `<article class="msg-container msg-remote ${item[7]}" id="msg-0"><div class="msg-box msg-${item[1]}">` +
                        `<img class="user-img" id="user-0" src="${item[4]}" />${item[6]}<div class="flr"><div class="messages"><p class="msg" id="msg-0">${item[0]}</p></div>`+
                        `<span class="timestamp"><span class="username">Вы</span>&bull;<span class="posttime"> ${item[2]} </span> &bull;` +
                        `${item[3]}</span></div></div></article>`;
                }
            });
            document.getElementById("chat-window").scrollTo(0,30000000000000);
        }
    }
    xhr.send()
}

function alert_about_choise(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function(e) {
            document.getElementById('file').innerText = 'Файл выбран';
            document.getElementById('file').style.color = 'black';
            document.getElementById('icon').style.color = 'black';
        }

        reader.readAsDataURL(input.files[0]);
    }
}
