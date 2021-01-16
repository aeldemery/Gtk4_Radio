// Copyright (c) 2021 Ahmed Eldemery
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

/**
* SessionManager manages Soup Session per application, like user agent, time out, max connections ...
 */
public class Gtk4Radio.SessionManager : Object {
    static Soup.Session session;

    /**
    * {@inheritDoc}
    *
    *@param user_agent string of the user agent for the session.
    *@param time_out time out for transactions, default is 15 seconds.
    *@param max_connections number of parallel connections, default is 8.
     */
    public SessionManager.init (string user_agent, uint time_out = 15, int max_connections = 8) {
        if (session == null) {
            session = new Soup.Session ();
            session.user_agent = user_agent;
            session.max_conns = max_connections;
            session.timeout = time_out;
        }
    }

    private SessionManager () {}

    public Soup.Session get_instance () {
        return session;
    }
}
