<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">

<?php
    require_once "db.php";
    session_start();

    if(!isset($_SESSION['admin_logged_in']) || $_SESSION['admin_logged_in'] == false){
        header('Location: admin_login.php');
        return;
    }

    $query = "SELECT SKID, PID, Start_Date, Pending_Charge
    FROM Shop" ;
    $res = $db -> query($query);
?>

<div style='padding: 15px'>
<h2>Details</h2>
    <table class="table table-striped">
        <thead>
        <tr>
            <th scope="col">SKID</th>
            <th scope="col">PID</th>
            <th scope="col">Start Date</th>
            <th scope="col">Pending Charge</th>
        </tr>
        </thead>
        <tbody>
<?php
    while ($row = $res -> fetch_row()) {
?>
        <tr>
            <th scope="row"><?php echo $row[0] ?></th>
            <th scope="row"><?php echo $row[1] ?></th>
            <th scope="row"><?php echo $row[2] ?></th>
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


