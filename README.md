# ExportServer

This is an almost verbatem port of Garrett Smith's
[port_server](https://github.com/gar1t/port_server) example for how to use
Erlang (or in this case Elixir) to extend Erlang supervision to external apps.

Here's Garrett's description:

> port_server is a simple set of example code that illustrates how an Erlang OTP
> application can be used to start, supervise and stop a set of related
> external applications.
>
> For background on this code, refer to doc/ceug-dec-2010.svg.
>
> The motivation for the presentation to the Chicago Erlang User Group was to
> provide a tangible benefit for using Erlang in non-Erlang environments.
>
> The gist:
>
> - Use Erlang ports to run external applications from a single Erlang node
>
> - Use OTP application supervisors to start, supervise, and shutdown the
>   applicable services
>
> - Refactor external applications written in other languages to be smaller,
>   more service oriented, and use a "fail fast and hard" pattern for error
>   handling

# Building

Install Erlang and Elixir on your system and run:

    $ iex compile

# Running

You'll need Python 2.x installed since the external applications are written
in Python. The scripts expect the Python interpreter to be `/usr/bin/python2`,
so if that's not the case on your system, edit the scripts to point to the right
version of Python. The scripts are in the `priv` directory.

To start Elixir and run the two services, run:

    $ iex -S mix

Now if you run `pgrep`, you should see the services running. For example,

    $ pgrep service_a
    9391
    $ pgrep service_b
    9392

If you kill a service (e.g., to simulate a crash), it will be restarted:

    $ pgrep service_a
    9391
    $ pkill service_a
    $ pgrep service_a
    9469

The supervisor is setup to allow for a maximum of 2 restarts in 5 seconds, so
if you kill a service too many times, too quickly, the application will fail and
the service won't be restarted. This is to prevent restarts from overloading the
system. However in this case, the threshold is set artificially low to make it
possible to trigger manually.

Garrett's repository has even more information on using Erlang to add
fault tolerance to non-Erlang applications. Everything applies to Elixir so if
you're considering writing an app in Elixir, you don't have to code everything
in Elixir in the beginning to take advantage of the Erlang VM.
