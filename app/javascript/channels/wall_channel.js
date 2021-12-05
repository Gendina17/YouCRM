import consumer from './consumer';

consumer.subscriptions.create("WallChannel", {
    connected() {
        alert('ddd')
    },

    disconnected () {

    },

    received (data) {
        console.log(data)

    }
});
