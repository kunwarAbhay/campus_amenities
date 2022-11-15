<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">

<?php
    require_once "db.php";
    session_start();

    $query = "SELECT * FROM Room
    WHERE isAvailable = 'T'" ;
    $res = $db -> query($query);
?>

<div style='padding: 15px'>
<h2>Details</h2>
    <table class="table table-striped">
        <thead>
        <tr>
            <th scope="col">RID</th>
            <th scope="col">Type</th>
            <th scope="col">Price</th>
            <th scope="col">Floor</th>
            <th scope="col">No of Beds</th>
            <th scope="col">AC</th>
            <th scope="col">GUID</th>
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
            <td><?php 
                if($row[5]=='T')
                    echo "Yes";
                else
                    echo "No";
            ?></td>
            <td><?php echo $row[7] ?></td>
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


