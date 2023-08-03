// Show a prompt to prevent users from accidentally
// go back, forward, refresh, or close the page
window.onbeforeunload = function () {
    return 'Your changes will be lost!';
};