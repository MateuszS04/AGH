<?php

if (!defined('IN_INDEX')) { exit("This file can only be included in index.php."); }

if (isset($_POST['opinion'])) {

    $opinion = $_POST['opinion'];

    if (mb_strlen($opinion) >= 5 && mb_strlen($opinion) <= 200) {

        $stmt = DB::getInstance()->prepare("INSERT INTO guestbook (opinion, ip, created) VALUES (:opinion, :ip, NOW())");
        $stmt->execute([':opinion' => $opinion, ':ip' => $_SERVER['REMOTE_ADDR']]);

        TwigHelper::addMsg('Entry has been added.', 'success');
    } else {
        TwigHelper::addMsg('Incorrect data.', 'error');
    }

} elseif (isset($_GET['delete'])) {

    $stmt = DB::getInstance()->prepare("DELETE FROM guestbook WHERE id = :id AND ip = :ip");
    $stmt->execute([':id' => intval($_GET['delete']), ':ip' => $_SERVER['REMOTE_ADDR']]);

    TwigHelper::addMsg('Entry has been deleted.', 'success');
}

$stmt = DB::getInstance()->prepare("SELECT * FROM guestbook");
$stmt->execute();
$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);


print TwigHelper::getInstance()->render('guestbook.html', [
    'rows' => $rows,
    'user_ip' => $_SERVER['REMOTE_ADDR']
]);
