<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">

<?php
    require_once "db.php";
    session_start();

    $query = "SELECT Guest.GID, Room.RID, Guest.Name, Room.Type, CONCAT(EXTRACT(YEAR FROM Bookings.DoA),'-',EXTRACT(MONTH FROM Bookings.DoA)) as Booking_Month, Bookings.DoD
    FROM Guest 
    INNER JOIN Bookings ON Bookings.GID = Guest.GID
    INNER JOIN Room ON Room.RID = Bookings.RID
    ORDER BY Booking_month DESC" ;
    $res = $db -> query($query);
?>

<div style='padding: 15px'>
<h2>Details</h2>
    <table class="table table-striped">
        <thead>
        <tr>
            <th scope="col">GID</th>
            <th scope="col">RID</th>
            <th scope="col">Guest Name</th>
            <th scope="col">Room Type</th>
            <th scope="col">Booking Month</th>
            <th scope="col">Date of Departure</th>
        </tr>
        </thead>
        <tbody>
<?php
    while ($row = $res -> fetch_row()) {
?>
        <tr>
            <th scope="row"><?php echo $row[0] ?></th>
            <th scope="row"><?php echo $row[1] ?></th>
            <td><?php echo $row[2] ?></td>
            <td><?php echo $row[3] ?></td>
            <td><?php echo $row[4] ?></td>
            <td><?php echo $row[5] ?></td>
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


