<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">

<?php
    require_once "db.php";
    session_start();
?>
<form method = post>
    <br><br>
    <div class="row align-items-center justify-content-center">
        <div class="form-group col-lg-3">
            <select class="form-control" name="year">
                <option value="" selected disabled>Select Year</option>
                <option value="2008">2008</option>
                <option value="2009">2009</option>
                <option value="2010">2010</option>
                <option value="2011">2011</option>
                <option value="2012">2012</option>
                <option value="2013">2013</option>
                <option value="2014">2014</option>
                <option value="2015">2015</option>
                <option value="2016">2016</option>
                <option value="2017">2017</option>
                <option value="2018">2018</option>
                <option value="2019">2019</option>
                <option value="2020">2020</option>
                <option value="2021">2021</option>
                <option value="2022">2022</option>
            </select><br>
            <select class="form-control" name="month">
                <option value="" selected disabled>Select Month</option>
                <option value="01">01</option>
                <option value="02">02</option>
                <option value="03">03</option>
                <option value="04">04</option>
                <option value="05">05</option>
                <option value="06">06</option>
                <option value="07">07</option>
                <option value="08">08</option>
                <option value="09">09</option>
                <option value="10">10</option>
                <option value="11">11</option>
                <option value="12">12</option>
            </select><br>
            <button type="submit" class="btn btn-success btn-lg btn-block" name="fetch_detail">Show Expenditure Information</button>
        </div>
    </div>
</form>

<div style='padding: 15px'>
<h2>Expenditure Details</h2>
<?php
    if(isset($_POST['fetch_detail'])){
        $query_year = $db->real_escape_string($_POST['year']);
        $query_month = $db->real_escape_string($_POST['month']);
        $query_yearMonth = $query_year."".$query_month;
        $query_yearMonth = (int)$query_yearMonth;

        $query = "CALL monthly_expenditure($query_yearMonth)" ;

        $res = $db -> query($query);
        if(empty($res->num_rows)){
            $_SESSION['no_data'] = 'No Data';
            header('Location: expenditure.php');
            return;
        }
?>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th scope="col">GUID</th>
                    <th scope="col">Year-Month</th>
                    <th scope="col">Amount</th>
                </tr>
            </thead>
            <tbody>
<?php
        while ($row = $res->fetch_assoc()) {
?>
            <tr>
                <th scope="row"><?php echo $row['GUID'] ?></th>
                <td><?php echo $row['YM'] ?></td>
                <td><?php echo $row['Total_Expenditure'] ?></td>
            </tr>
<?php
        }
?>
            </tbody>
        </table>
<?php
    }
    if (isset($_SESSION['no_data'])) {
        echo('<p style="color:red">'.$_SESSION['no_data'].'</p>'."\n");
        unset($_SESSION['no_data']);
    }
?>
</div>

<div class="col-md-8">
    <a href="home_guest_house.php" class="btn btn-primary">Go Back</a>
</div>