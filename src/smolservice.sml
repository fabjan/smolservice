(*
 * Copyright 2023 Fabian Bergström
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *)

(*
 * A simple echo server.
 *)

fun sendStr (s, str) =
  Socket.sendVec (s, Word8VectorSlice.full (Byte.stringToBytes str))

fun optOr NONE y = y
  | optOr (SOME x) _ = x

(* The handler loop is spawned for each connecting client *)
fun handleConnection s = (
    sendStr (s, "Welcome to the echo server!\r\n");
    sendStr (s, "Type 'quit' to exit.\r\n");
    echoLoop s;
    Socket.close s;
    print "Closed the connection.\n"
)
and echoLoop s =
  let
    val bytes = Socket.recvVec (s, 1024)
    val str = Byte.bytesToString bytes
  in
    case str of
      "quit\r\n" => sendStr (s, "Bye!\r\n")
    | _ => (sendStr (s, str); echoLoop s)
  end

(* The server entry point enters this loop waiting for connections *)
fun acceptLoop server_sock =
  let
    val _ = print "Waiting for connection...\n"
    val (s, _) = Socket.accept server_sock
  in
    print "Accepted connection, forking handler...\n";
    case Posix.Process.fork () of
      NONE => handleConnection s
    | SOME _ => acceptLoop server_sock
  end

fun main () =
  let
    val s = INetSock.TCP.socket ()
    val portOpt = Option.mapPartial Int.fromString (OS.Process.getEnv "PORT")
    val port = optOr portOpt 8989
  in
    Socket.Ctl.setREUSEADDR (s, true);
    Socket.bind (s, INetSock.any port);
    Socket.listen (s, 5);
    print ("Listening on port " ^ (Int.toString port) ^ "\n");
    acceptLoop s
  end
