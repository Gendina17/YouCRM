function send_form_new() {
    var email = document.forms.newForm.email.value;
    var name = document.forms.newForm.name.value;
    var surname = document.forms.newForm.surname.value;
    var password = document.forms.newForm.password.value;
    var password_confirmation = document.forms.newForm.password_confirmation.value;
    var token = document.forms.newForm.authenticity_token.value
    var role = document.forms.newForm.role.value
    var xhr = new XMLHttpRequest();

    xhr.open("POST", "/create.json")
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    body = 'email=' + encodeURIComponent(email) +
        '&name=' + encodeURIComponent(name) +
        '&surname=' + encodeURIComponent(surname) +
        '&password_confirmation=' + encodeURIComponent(password_confirmation) +
        '&password=' + encodeURIComponent(password) +
        '&role_id=' + encodeURIComponent(role) +
        '&authenticity_token=' + encodeURIComponent(token);

    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4 && xhr.status == 200) {
            document.getElementById('reg_error').innerText = xhr.responseText;
            document.getElementById('reg_error').style.display = 'block'
            document.getElementById('block_registration').style.maxHeight = "650px";
            document.getElementById('block_registration').style.height = "650px";
            document.getElementById('close_reg').style.top = "130px";
        }
    }
    xhr.send(body)
    return false
}

function show_hide_password(target){
    var input = document.getElementById('password-input');

    if (input.getAttribute('type') == 'password') {
        target.classList.add('view');
        input.setAttribute('type', 'text');
    } else {
        target.classList.remove('view');
        input.setAttribute('type', 'password');
    }
    return false;
}

document.addEventListener('keyup', function(event) {
    const wrapper = document.querySelector(".input-wrapper")
    wrapper.setAttribute("data-text", event.target.value);
    search_user();
});

function search_user() {
    el = document.getElementById("my-input")
    const searchFor = el.value.toLowerCase();
    const $rooms = $("#user-list"),
        $roomsList = $rooms.children();

    $roomsList.each(function () {
        const name = $(this).find("#name").text().toLowerCase();
        const surname = $(this).find("#surname").text().toLowerCase();
        const fullname = name + " " + surname;
        const reversename = surname + " " + name;

        if (name.includes(searchFor) || surname.includes(searchFor) ||
            fullname.includes(searchFor) || reversename.includes(searchFor)) {
            $(`#${this.id}`).show();
        } else {
            $(`#${this.id}`).hide();
        }
    });
}

function getRandomInt(max) {
    return Math.floor(Math.random() * max);
}

function show_user(name, surname, state, mood, info, role, mail, contacts, time, avatar) {
    document.getElementById('user_title').innerHTML = `Пользователь ${surname} ${name} ${role} ${state}`;
    document.getElementById('user-mood').innerHTML = `${mood}`;
    document.getElementById('info').innerHTML = `${info}`;
    document.getElementById('mail').innerHTML = `${mail}`;
    document.getElementById('time').innerHTML = `В YouCrm с ${time}`;
    contacts = contacts.split('#')
    document.getElementById('contact_list').innerHTML = ''

    if (contacts == '')
        return

    for(i = 0; i < contacts.length; i++) {
        site = contacts[i].split('-')[0]
        nick = contacts[i].split('-')[1]
        if (['telegram', 'slack' , 'whatsapp' , 'phone', 'github'].indexOf( site ) == -1)
            site2 = 'another'
        else
            site2 = site
        document.getElementById('contact_list').innerHTML += `<img class="icons" src="../assets/white-${site2}.svg"` +
            `title="${site}"> ${nick} <br>`;
    }

    value = getRandomInt(6)+1
    document.getElementById('user_avatar').src = `../assets/avatar${value}.jpeg`

    if (avatar !== ''){
        document.getElementById('user_avatar').src = avatar
    } else {
        value = getRandomInt(6)+1
        document.getElementById('user_avatar').src = `../assets/avatar${value}.jpeg`
    }
}
