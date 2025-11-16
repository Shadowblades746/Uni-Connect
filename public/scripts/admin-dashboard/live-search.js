searchInputBox = document.getElementById("searchBox");
searchTable = document.getElementById("tableFrame");

function updateTable()
{
    value = searchInputBox.value;
    value = value.replace(" ", "+") // Remove spaces from input
    searchTable.src = "/admin-private/user-search-page?searchterm=" + value; //Replace 'logout' with the route for the table
}

searchInputBox.addEventListener('keyup', () => updateTable(),false);