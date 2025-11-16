timer = document.getElementById("countdown");
timer.innerHTML = "5";
setTimeout(() => {
    timer.innerHTML = "4"
}, 1000);
setTimeout(() => {
    timer.innerHTML = "3"
}, 2000);
setTimeout(() => {
    timer.innerHTML = "2"
}, 3000);
setTimeout(() => {
    timer.innerHTML = "1"
}, 4000);
setTimeout(() => {
    timer.innerHTML = "0"
    window.location = "/"
}, 5000);