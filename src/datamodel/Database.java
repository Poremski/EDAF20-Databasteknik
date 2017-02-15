package datamodel;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Database is a class that specifies the interface to the 
 * movie database. Uses JDBC and the MySQL Connector/J driver.
 */
public class Database {
    /** 
     * The database connection.
     */
    private Connection conn;
    private String currName;
        
    /**
     * Create the database interface object. Connection to the database
     * is performed later.
     */
    public Database() {
        conn = null;
    }
        
    /** 
     * Open a connection to the database, using the specified user name
     * and password.
     *
     * @param userName The user name.
     * @param password The user's password.
     * @return true if the connection succeeded, false if the supplied
     * user name and password were not recognized. Returns false also
     * if the JDBC driver isn't found.
     */
    public boolean openConnection(String userName, String password) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection 
                ("jdbc:mysql://localhost/" + userName,
                 userName, password);
        }
        catch (SQLException e) {
            System.err.println(e);
            e.printStackTrace();
            return false;
        }
        catch (ClassNotFoundException e) {
            System.err.println(e);
            e.printStackTrace();
            return false;
        }
        return true;
    }
        
    /**
     * Close the connection to the database.
     */
    public void closeConnection() {
        try {
            if (conn != null)
                conn.close();
        }
        catch (SQLException e) {
        	e.printStackTrace();
        }
        conn = null;
        
        System.err.println("Database connection closed.");
    }
        
    /**
     * Check if the connection to the database has been established
     *
     * @return true if the connection has been established
     */
    public boolean isConnected() {
        return conn != null;
    }
	
  	public Show getShowData(String mTitle, String mDate) {

		Integer mFreeSeats = 0;
		String mVenue = null;

		try {
		    ResultSet rs = conn.createStatement()
                    .executeQuery("SELECT * FROM Shows WHERE day = '" + mDate + "' AND movieName = '" + mTitle + "'");

		    while (rs.next()) {
		        mFreeSeats = rs.getInt("freeSeats");
		        mVenue = rs.getString("theaterName");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

		
		return new Show(mTitle, mDate, mVenue, mFreeSeats);
	}

    public boolean login(String uname) {

        try {
            ResultSet rs = conn.createStatement()
                    .executeQuery("SELECT username FROM Users WHERE username = '" + uname + "'");
            if (rs.next()) {
                currName = uname;
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<String> getDates(String m) {
        List<String> dates = new ArrayList<>();

        try {
            ResultSet rs = conn.createStatement()
                    .executeQuery("SELECT day FROM Shows WHERE movieName = '" + m + "'");
            while (rs.next()) {
                dates.add(rs.getString("day"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return dates;
    }

    public List<String> getMovies() {
        List<String> movies = new ArrayList<>();

        try {
            ResultSet rs = conn.createStatement()
                    .executeQuery("SELECT DISTINCT(movieName) AS mName FROM Shows");
            while (rs.next()) {
                movies.add(rs.getString("mName"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return movies;
    }

    public Integer bookTicket(String movieName, String date) {
        String theaterName = null;
        int freeSeats = 0;
        Integer bookingNbr = 0;

        PreparedStatement ps = null;

        try {
            conn.setAutoCommit(false);

            ps = conn.prepareStatement("SELECT theaterName, freeSeats FROM Shows WHERE movieName = ? AND day = ?");
            ps.setString(1, movieName);
            ps.setString(2, date);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                theaterName = rs.getString(1);
                freeSeats = rs.getInt(2);
            }

            if (freeSeats < 1) {
                conn.rollback();
                return null;
            } else {
                ps = conn.prepareStatement("INSERT INTO Reservations VALUES (null, ?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS);
                ps.setString(1, currName);
                ps.setString(2, movieName);
                ps.setString(3, theaterName);
                ps.setString(4, date);
                ps.executeUpdate();
                rs = ps.getGeneratedKeys();
                rs.next();
                bookingNbr = rs.getInt(1);

                ps = conn.prepareStatement("UPDATE Shows SET freeSeats=? WHERE movieName = ? AND day = ? AND freeSeats > 0");
                ps.setInt(1, freeSeats-1);
                ps.setString(2, movieName);
                ps.setString(3, date);
                ps.executeUpdate();

                conn.commit();
                conn.setAutoCommit(true);

                ps = conn.prepareStatement("SELECT nbr FROM Reservation WHERE username = " + currName + " AND ");

                return bookingNbr;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

}
