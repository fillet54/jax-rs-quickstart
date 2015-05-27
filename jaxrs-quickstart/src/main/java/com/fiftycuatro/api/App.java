package com.fiftycuatro;

import java.util.List;
import java.util.ArrayList;

import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.GET;
import javax.ws.rs.core.MediaType;

@Path("/helloworld")
public class App 
{
    @GET
    @Path("/")
    @Produces(MediaType.APPLICATION_JSON)
    public Object getHelloWorld() {
        return "Hello World";
    }

    @GET
    @Path("/list")
    @Produces(MediaType.APPLICATION_JSON)
    public Object getList() {
        List<String> vals = new ArrayList<String>();
        vals.add("One");
        vals.add("Two");
        vals.add("Three");
        return vals;
    }
}
