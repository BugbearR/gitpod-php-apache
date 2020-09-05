<?php
/** html escape for textContent */
function ht($s) {
    return htmlspecialchars($s, ENT_HTML5 | ENT_SUBSTITUTE | ENT_DISALLOWED | ENT_NOQUOTES, 'UTF-8');
}
/** html escape for attribute */
function ha($s) {
    return htmlspecialchars($s, ENT_HTML5 | ENT_SUBSTITUTE | ENT_DISALLOWED | ENT_QUOTES, 'UTF-8');
}

$title = "Hello, world!";
?>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title><?=ht($title)?></title>
  </head>
  <body>
    <h1><?=ht($title)?></h1>
  </body>
</html>
