function load_files(ticket_id) {
    var xhr = new XMLHttpRequest();
    params = 'id=' + encodeURIComponent(ticket_id);

    xhr.open("GET", "/show_files?" + params)

    xhr.onreadystatechange = function (){
        if (xhr.readyState == 4 && xhr.status == 200) {
            data = JSON.parse(xhr.responseText)
            if (data['key'] == false) {
                document.getElementById('files').innerHTML = data['message']
            } else {
                document.getElementById('files').innerHTML = ''
                data = data['data']
                for (var i = 0; i < data.length; i++) {
                    document.getElementById('files').innerHTML += `<a class="file_a" target="_blank" href="${data[i][0]}">${data[i][1]}</a><br>`
                }
            }
        }
    }
    xhr.send()
    document.getElementById('input_for_id').value = ticket_id;
}

function alert_about_choise(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function(e) {
            document.getElementById('file').innerText = 'Файл выбран';
            document.getElementById('file').style.color = 'black';
        }
        reader.readAsDataURL(input.files[0]);
    }
}

function show_block_product(name){
    document.getElementById(name).classList.remove('hidden');
}

function create_client(type) {
    var xhr = new XMLHttpRequest();

    xhr.open("POST", "/create_client")
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    if (type == 'human') {
        var name = document.forms.humanForm.name.value;
        var surname = document.forms.humanForm.surname.value;
        var patronymic = document.forms.humanForm.patronymic.value;
        var phone = document.forms.humanForm.phone.value;
        var email = document.forms.humanForm.email.value;
        var address = document.forms.humanForm.address.value;
        var password = document.forms.humanForm.password.value;
        var description = document.forms.humanForm.description.value;
        var manager_id = document.forms.humanForm.manager_id.value;
        var token = document.forms.humanForm.authenticity_token.value

        body = 'name=' + encodeURIComponent(name) +
            '&surname=' + encodeURIComponent(surname) +
            '&patronymic=' + encodeURIComponent(patronymic) +
            '&phone=' + encodeURIComponent(phone) +
            '&email=' + encodeURIComponent(email) +
            '&address=' + encodeURIComponent(address) +
            '&password=' + encodeURIComponent(password) +
            '&description=' + encodeURIComponent(description) +
            '&manager_id=' + encodeURIComponent(manager_id) +
            '&authenticity_token=' + encodeURIComponent(token) +
            '&type=' + encodeURIComponent(type);
    } else {
        var name = document.forms.clientCompanyForm.name.value;
        var phone = document.forms.clientCompanyForm.phone.value;
        var email = document.forms.clientCompanyForm.email.value;
        var address = document.forms.clientCompanyForm.address.value;
        var responsible = document.forms.clientCompanyForm.responsible.value;
        var description = document.forms.clientCompanyForm.description.value;
        var manager_id = document.forms.clientCompanyForm.manager_id.value;
        var token = document.forms.clientCompanyForm.authenticity_token.value

        body = 'name=' + encodeURIComponent(name) +
            '&phone=' + encodeURIComponent(phone) +
            '&email=' + encodeURIComponent(email) +
            '&address=' + encodeURIComponent(address) +
            '&responsible=' + encodeURIComponent(responsible) +
            '&description=' + encodeURIComponent(description) +
            '&manager_id=' + encodeURIComponent(manager_id) +
            '&authenticity_token=' + encodeURIComponent(token) +
            '&type=' + encodeURIComponent(type);
    }

    xhr.onreadystatechange = function (){
        if (xhr.readyState == 4 && xhr.status == 200) {

            data = JSON.parse(xhr.responseText);

            if (data['success'] === false) {
                document.getElementById('alert').innerText = data['message']
                return
            }

            client_info = data['client'];
            type_client = data['type_client']
            i = getRandomInt(4) + 1

            document.getElementById('client_info2').innerHTML += `<img id="avatar_client" src="../assets/client_avatar${i}.png"><div id="client_name_block"><span id="client_name" type_object='client'  name='name'>${client_info.name}</span> <span id="client_surname"  name='surname' type_object='client'>${type_client == 'human' ? (client_info.surname == null ? '..' : client_info.surname) : ''}</span><br><span id="client_patronymic" name='patronymic' type_object='client' >${type_client == 'human' ? (client_info.patronymic == null ? '...' : client_info.patronymic) : ''}</span></div><br><div id="client_description_block"><span id="client_description" type_object='client' name='description' >${client_info.description = null ? '...' : client_info.description }</span></div>` +
                `<div id="client_contacts"><span><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-telephone" viewBox="0 0 16 16"><path d="M3.654 1.328a.678.678 0 0 0-1.015-.063L1.605 2.3c-.483.484-.661 1.169-.45 1.77a17.568 17.568 0 0 0 4.168 6.608 17.569 17.569 0 0 0 6.608 4.168c.601.211 1.286.033 1.77-.45l1.034-1.034a.678.678 0 0 0-.063-1.015l-2.307-1.794a.678.678 0 0 0-.58-.122l-2.19.547a1.745 1.745 0 0 1-1.657-.459L5.482 8.062a1.745 1.745 0 0 1-.46-1.657l.548-2.19a.678.678 0 0 0-.122-.58L3.654 1.328zM1.884.511a1.745 1.745 0 0 1 2.612.163L6.29 2.98c.329.423.445.974.315 1.494l-.547 2.19a.678.678 0 0 0 .178.643l2.457 2.457a.678.678 0 0 0 .644.178l2.189-.547a1.745 1.745 0 0 1 1.494.315l2.306 1.794c.829.645.905 1.87.163 2.611l-1.034 1.034c-.74.74-1.846 1.065-2.877.702a18.634 18.634 0 0 1-7.01-4.42 18.634 18.634 0 0 1-4.42-7.009c-.362-1.03-.037-2.137.703-2.877L1.885.511z"/>`+
                `</svg> <span name='phone' type_object='client'>${client_info.phone == null ? '...' : client_info.phone}</span> </span><br><span><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-envelope" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M0 4a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V4Zm2-1a1 1 0 0 0-1 1v.217l7 4.2 7-4.2V4a1 1 0 0 0-1-1H2Zm13 2.383-4.708 2.825L15 11.105V5.383Zm-.034 6.876-5.64-3.471L8 9.583l-1.326-.795-5.64 3.47A1 1 0 0 0 2 13h12a1 1 0 0 0 .966-.741ZM1 11.105l4.708-2.897L1 5.383v5.722Z"/>` +
                `</svg> <span name='email' type_object='client'>${client_info.email == null ? '...' : client_info.email}</span></span><br><span><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-house-door" viewBox="0 0 16 16"><path d="M8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4.5a.5.5 0 0 0 .5-.5v-4h2v4a.5.5 0 0 0 .5.5H14a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.354 1.146zM2.5 14V7.707l5.5-5.5 5.5 5.5V14H10v-4a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 0-.5.5v4H2.5z"/></svg> <span name='address' type_object='client'>${client_info.address == null ? '...' : client_info.address}</span></span><br><span> <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-file-person" viewBox="0 0 16 16">` +
                `<path d="M12 1a1 1 0 0 1 1 1v10.755S12 11 8 11s-5 1.755-5 1.755V2a1 1 0 0 1 1-1h8zM4 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H4z"/><path d="M8 10a3 3 0 1 0 0-6 3 3 0 0 0 0 6z"/></svg> <span name='password' type_object='client'>${type_client == 'human' ? (client_info.password == null ? '...' : client_info.password) : (client_info.responsible == null ? '...' : client_info.responsible )}</span></span></div><span id="client_manager">${client_info.manager == null ? '...' : client_info.manager}</span><div id="client_attach"><span ><svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="#848484" class="bi bi-coin" viewBox="0 0 16 16">` +
                `<path d="M5.5 9.511c.076.954.83 1.697 2.182 1.785V12h.6v-.709c1.4-.098 2.218-.846 2.218-1.932 0-.987-.626-1.496-1.745-1.76l-.473-.112V5.57c.6.068.982.396 1.074.85h1.052c-.076-.919-.864-1.638-2.126-1.716V4h-.6v.719c-1.195.117-2.01.836-2.01 1.853 0 .9.606 1.472 1.613 1.707l.397.098v2.034c-.615-.093-1.022-.43-1.114-.9H5.5zm2.177-2.166c-.59-.137-.91-.416-.91-.836 0-.47.345-.822.915-.925v1.76h-.005zm.692 1.193c.717.166 1.048.435 1.048.91 0 .542-.412.914-1.135.982V8.518l.087.02z"/><path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/><path d="M8 13.5a5.5 5.5 0 1 1 0-11 5.5 5.5 0 0 1 0 11zm0 .5A6 6 0 1 0 8 2a6 6 0 0 0 0 12z"/></svg> <span name='points' type_object='client'>${client_info.points == null ? '...' : client_info.points}</span></span></div></div>`
            document.getElementById('nothing_selected').style.display = 'none'
            document.getElementById('client2').style.display='block';
            path = "http://localhost:3000/#close";
            window.location.href = path;
        }
    }
    xhr.send(body)
}

function update_params() {
    ticket_id = document.getElementById('id_fot_templates').value
    type = document.forms.updateForm.type.value;

    body = 'ticket_id=' + encodeURIComponent(ticket_id) +
        '&type=' + encodeURIComponent(type);

    switch(type) {
        case 'manager_client':
            manager_id = document.forms.updateForm.manager1.value;
            body += '&manager_id=' + encodeURIComponent(manager_id);
            break
        case 'status_update':
            status_id = document.forms.updateForm.status.value;
            body += '&status_id=' + encodeURIComponent(status_id);
            break
        case 'category_update':
            category_id = document.forms.updateForm.category.value;
            body += '&category_id=' + encodeURIComponent(category_id);
            break
        case 'manager_ticket':
            manager_id = document.forms.updateForm.manager2.value;
            body += '&manager_id=' + encodeURIComponent(manager_id);
            break
        case 'date':
            date = document.forms.updateForm.date.value;
            body += '&date=' + encodeURIComponent(date);
            break
    }

    var xhr = new XMLHttpRequest();

    xhr.open("GET", "/update_params?" + body)
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    xhr.onreadystatechange = function (){
        if (xhr.readyState == 4 && xhr.status == 200) {
            data = JSON.parse(xhr.responseText)
            type = data['type']
            value = data['value']

            switch(type) {
                case 'manager_client':
                    document.getElementById('manager_client_value').innerHTML = value
                    break
                case 'status_update':
                    document.getElementById('status_update_value').innerHTML = value
                    break
                case 'category_update':
                    document.getElementById('category_update_value').innerHTML = value
                    break
                case 'manager_ticket':
                    document.getElementById('manager_ticket_value').innerHTML = value
                    break
                case 'date':
                    document.getElementById('date_value').innerHTML = value
                    break
            }
        }
    }
    xhr.send()
    path = "http://localhost:3000/#close";
    window.location.href = path;
}

function select_type_params(type) {
    document.getElementById('type_for_update').value = type
    document.getElementById('manager_client').classList.add('hidden')
    document.getElementById('status_update').classList.add('hidden')
    document.getElementById('category_update').classList.add('hidden')
    document.getElementById('manager_ticket').classList.add('hidden')
    document.getElementById('date').classList.add('hidden')
    document.getElementById(type).classList.remove('hidden')
}
