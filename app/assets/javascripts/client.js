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
