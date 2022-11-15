<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">

<?php
    require_once "db.php";
    session_start();

    if(!isset($_SESSION['admin_logged_in']) || $_SESSION['admin_logged_in'] == false){
        header('Location: admin_login.php');
        return;
    }


    $query = "SELECT * FROM Plot
    WHERE PID NOT IN (
        SELECT PID FROM Shop
        WHERE DATE_ADD(Start_Date,INTERVAL (License_Period+Extension_Period) MONTH) > CURDATE()
    );" ;
    $res = $db -> query($query);
?>

<div style='padding: 15px'>
<h2>Details</h2>
    <table class="table table-striped">
        <thead>
        <tr>
            <th scope="col">PID</th>
            <th scope="col">Location</th>
            <th scope="col">Size</th>
            <th scope="col">Rent</th>
        </tr>
        </thead>
        <tbody>
<?php
    while ($row = $res -> fetch_row()) {
?>
        <tr>
            <th scope="row"><?php echo $row[0] ?></th>
            <td><?php echo $row[1] ?></td>
            <td><?php echo $row[2] ?></td>
            <td><?php echo $row[3] ?></td>
        </tr>
<?php
    }
?>
        </tbody>
    </table>
</div>

<div class="col-md-8">
    <a href="home_market.php" class="btn btn-primary">Go Back</a>
</div>


