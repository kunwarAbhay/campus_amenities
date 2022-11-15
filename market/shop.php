<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">

<?php
    require_once "db.php";
    session_start();

    if(!isset($_SESSION['admin_logged_in']) || $_SESSION['admin_logged_in'] == false){
        header('Location: admin_login.php');
        return;
    }

    $query = "SELECT Shopkeeper.SKID, Plot.PID, Shop.Start_Date, Shopkeeper.Name,
    Plot.Location, Plot.Rent, 
    Shop.Category, Shop.License_Period, Shop.Extension_Period, Shop.Pending_Charge, Shop.Performance 
    FROM Shop 
    INNER JOIN Shopkeeper ON Shopkeeper.SKID = Shop.SKID
    INNER JOIN Plot ON Plot.PID = Shop.PID" ;
    $res = $db -> query($query);
?>

<div style='padding: 15px'>
<h2>Details</h2>
    <table class="table table-striped">
        <thead>
        <tr>
            <th scope="col">SKID</th>
            <th scope="col">PID</th>
            <th scope="col">Shop Start Date</th>
            <th scope="col">Shopkeeper Name</th>
            <th scope="col">Location</th>
            <th scope="col">Rent</th>
            <th scope="col">Category</th>
            <th scope="col">License Period</th>
            <th scope="col">Extension Period</th>
            <th scope="col">Pending Charge</th>
            <th scope="col">Performance</th>
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
            <td><?php echo $row[4] ?></td>
            <td><?php echo $row[5] ?></td>
            <td><?php echo $row[6] ?></td>
            <td><?php echo $row[7] ?></td>
            <td><?php echo $row[8] ?></td>
            <td><?php echo $row[9] ?></td>
            <td><?php echo $row[10] ?></td>
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


