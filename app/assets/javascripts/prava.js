function create_role(){
    var name = document.forms.roleForm.name.value;
    var description = document.forms.roleForm.description.value;
    var token = document.forms.roleForm.authenticity_token.value

    form = document.getElementById('roleForm');
    r = document.getElementsByClassName('tttt');

    var xhr = new XMLHttpRequest();

    xhr.open("POST", "/create_role.json")
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    body = 'name=' + encodeURIComponent(name) +
        '&description=' + encodeURIComponent(description) +
        '&authenticity_token=' + encodeURIComponent(token);

    for (i = 0; i<r.length/2; i++){
        if (r[i].checked){
            body += `&permission[${i}]=` + encodeURIComponent(r[i].value)
        }
    }

    xhr.onreadystatechange = function () {
        if (xhr.readyState == 4 && xhr.status == 200) {
            document.getElementById('role_alert').innerText = xhr.responseText;
        }
    }
    xhr.send(body)
    return false
}

function create_role_user(){
    var user = document.forms.roleUserForm.user.value;
    var role = document.forms.roleUserForm.role.value;
    var token = document.forms.roleUserForm.authenticity_token.value;

    var xhr = new XMLHttpRequest();
    xhr.open("POST", "/add_role_to_user.json");
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    body = 'user_id=' + encodeURIComponent(user) +
        '&role_id=' + encodeURIComponent(role) +
        '&authenticity_token=' + encodeURIComponent(token);

    xhr.onreadystatechange = function (){
        if (xhr.readyState == 4 && xhr.status == 200) {
            document.getElementById("role_alert").innerHTML = xhr.responseText;
        }
    }
    xhr.send(body)
}

function show_users(id, name){
    document.getElementById(name).classList.toggle("hidden");
    var xhr = new XMLHttpRequest();

    var params = 'id=' + encodeURIComponent(id);

    xhr.open("GET", "/all_users_in_role?" + params)

    xhr.onreadystatechange = function (){
        if (xhr.readyState == 4 && xhr.status == 200) {
            data = JSON.parse(xhr.responseText)

            if (data.length == 0) {
                document.getElementById(name).innerHTML = "<span id='no_users'>Пользователей с данной " +
                    "должностью не существует</span>"
            } else {
                list_users = ``
                for(i = 0; i < data.length; i++){
                    list_users += `<li>${data[i][0]} ${data[i][1]} <span id='no_users'> ( ${data[i][2]} )</span></li>`
                }
                document.getElementById(name).innerHTML = list_users
            }
        }
    }
    xhr.send()
}

function dell_role(id) {
    if (!confirm("Вы уверены что хотите удалить должность? Это необратимый процесс.")) {
        return
    } else {
        var xhr = new XMLHttpRequest();
        var params = 'id=' + encodeURIComponent(id);
        xhr.open("GET", "/dell_role?" + params)

        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4 && xhr.status == 200) {
                data = JSON.parse(xhr.responseText)
                if (data[0] == 0) {
                    alert(data[1])
                } else {
                    document.getElementById(`li-${data[1]}`).style.display = 'none'
                }
            }
        }
        xhr.send()
    }
}

function show_roles(id){
    document.getElementById(`role_actions_${id}`).classList.toggle("hidden");
}

function update_role(id) {
    var token = document.forms.updateRoleForm.authenticity_token.value;
    r = document.getElementsByClassName(`wwww-${id}`);

    var xhr = new XMLHttpRequest();
    xhr.open("POST", "/update_role.json");
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

    body = 'authenticity_token=' + encodeURIComponent(token) +
        '&id=' + encodeURIComponent(id);

    for (i = 0; i<r.length/2; i++){
        if (r[i].checked){
            body += `&permission[${i}]=` + encodeURIComponent(r[i].value)
        }
    }

    xhr.onreadystatechange = function (){
        if (xhr.readyState == 4 && xhr.status == 200) {
            document.getElementById("role_alert").innerHTML = xhr.responseText;
        }
    }
    xhr.send(body)
}
