<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">

<?php
    require_once "db.php";
    session_start();

    $query = "SELECT Staff.SID, Staff.Name, Guest_House.GUID, Guest_House.Name, WorksIn.Date
    FROM Guest_House
    INNER JOIN WorksIn ON Guest_House.GUID = WorksIn.GUID
    INNER JOIN Staff ON Staff.SID = WorksIn.SID
    ORDER BY WorksIn.Date DESC" ;
    $res = $db -> query($query);
?>

<div style='padding: 15px'>
<h2>Details</h2>
    <table class="table table-striped">
        <thead>
        <tr>
            <th scope="col">SID</th>
            <th scope="col">Staff Name</th>
            <th scope="col">GUID</th>
            <th scope="col">Guest House Name</th>
            <th scope="col">Date</th>
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


