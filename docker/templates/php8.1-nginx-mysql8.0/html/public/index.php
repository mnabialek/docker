<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>${domain}</title>
</head>
<body>
<p style="text-align: center; margin: 30px auto;">
    This is default index.php for <strong>${domain}</strong> site. You can
    safely remove this file. It's running
    <strong>PHP <?php echo phpversion(); ?></strong> on host <strong><?php echo $_SERVER['HTTP_HOST']; ?></strong>
</p>
<?php echo phpinfo(); ?>
</body>
</html>
