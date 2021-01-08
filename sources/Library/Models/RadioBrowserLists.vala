// Copyright (c) 2021 Ahmed Eldemery
// 
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

/** Object represent a Country in a list of all countries in the database. */
public class Gtk4Radio.Country : Object {
    public string name {get; set; default = "";}
    public int stationcount { get; set; default = 0;}

    public string to_string () {
        return @"name = $name\nstationcount = $stationcount";
    }
}

/** Object represent a Country Code in a list of all countries in the database. */
public class Gtk4Radio.CountryCode : Object {
    public string name {get; set; default = "";}
    public int stationcount { get; set; default = 0;}

    public string to_string () {
        return @"name = $name\nstationcount = $stationcount";
    }
}

/** Object represent a Codec in a list of all codecs in the database. */
public class Gtk4Radio.Codec : Object {
    public string name {get; set; default = "";}
    public int stationcount { get; set; default = 0;}

    public string to_string () {
        return @"name = $name\nstationcount = $stationcount";
    }
}

/** Object represent a State of a Contry in a list of all states in the database. */
public class Gtk4Radio.State : Object {
    public string name {get; set; default = "";}
    public string country {get; set; default = "";}
    public int stationcount { get; set; default = 0;}

    public string to_string () {
        return @"name = $name\ncountry = $country\nstationcount = $stationcount";
    }
}

/** Object represent a Language in a list of all languages in the database. */
public class Gtk4Radio.Language : Object {
    public string name {get; set; default = "";}
    public int stationcount { get; set; default = 0;}

    public string to_string () {
        return @"name = $name\nstationcount = $stationcount";
    }
}

/** Object represent a Tag in a list of all tags in the database. */
public class Gtk4Radio.Tag : Object {
    public string name {get; set; default = "";}
    public int stationcount { get; set; default = 0;}

    public string to_string () {
        return @"name = $name\nstationcount = $stationcount";
    }
}