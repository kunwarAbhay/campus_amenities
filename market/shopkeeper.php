<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">

<?php
    require_once "db.php";
    session_start();

    if(!isset($_SESSION['admin_logged_in']) || $_SESSION['admin_logged_in'] == false){
        header('Location: admin_login.php');
        return;
    }

    $query = "SELECT * FROM Shopkeeper" ;
    $res = $db -> query($query);
?>

<div style='padding: 15px'>
<h2>Details</h2>
    <table class="table table-striped">
        <thead>
        <tr>
            <th scope="col">SKID</th>
            <th scope="col">Name</th>
            <th scope="col">Date of Birth</th>
            <th scope="col">Street Address</th>
            <th scope="col">District</th>
            <th scope="col">State</th>
            <th scope="col">Zip Code</th>
            <th scope="col">Date of Application</th>
            <th scope="col">Security Pass Validation</th>
            <th scope="col">Contact Number</th>
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
            <td><?php echo $row[4] ?></td>
            <td><?php echo $row[5] ?></td>
            <td><?php echo $row[6] ?></td>
            <td><?php echo $row[7] ?></td>
            <td><?php echo $row[8] ?></td>
            <td><?php echo $row[9] ?></td>
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


