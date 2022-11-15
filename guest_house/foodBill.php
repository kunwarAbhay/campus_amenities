<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">

<?php
    require_once "db.php";
    session_start();

    $query = "SELECT Bill.BID, Bill.GID, EXTRACT(YEAR_MONTH FROM Bill.Date) AS Food_Billing_Month, Bill.Amount, Food_Service.Food_Item FROM Bill
    INNER JOIN Food_Service ON Bill.BID = Food_Service.BFID
    GROUP BY Food_Billing_Month" ;
    $res = $db -> query($query);
?>

<div style='padding: 15px'>
<h2>Details</h2>
    <table class="table table-striped">
        <thead>
        <tr>
            <th scope="col">BID</th>
            <th scope="col">GID</th>
            <th scope="col">Billing Month</th>
            <th scope="col">Amount</th>
            <th scope="col">Food Item</th>
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
        </tr>
<?php
    }
?>
        </tbody>
    </table>
</div>

<div class="col-md-8">
    <a href="home_guest_house.php" class="btn btn-primary">Go Back</a>
</div>


