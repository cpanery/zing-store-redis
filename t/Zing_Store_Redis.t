use 5.014;

use strict;
use warnings;
use routines;

use lib 't/app';
use lib 't/lib';

use Test::Auto;
use Test::More;

=name

Zing::Store::Redis

=cut

=tagline

Redis Storage

=cut

=abstract

Redis Storage Abstraction

=cut

=includes

method: drop
method: encode
method: keys
method: decode
method: lpull
method: lpush
method: recv
method: rpull
method: rpush
method: send
method: size
method: slot
method: test

=cut

=synopsis

  use Zing::Store::Redis;
  use Zing::Encoder::Dump;

  my $redis = Zing::Store::Redis->new(
    encoder => Zing::Encoder::Dump->new
  );

  # $redis->drop;

=cut

=libraries

Zing::Types

=cut

=attributes

client: ro, opt, InstanceOf["Redis"]

=cut

=inherits

Zing::Store

=cut

=description

This package provides a L<Redis> storage adapter for use with data persistence
abstractions.

=cut

=method drop

The drop method removes (drops) the item from the datastore.

=signature drop

drop(Str $key) : Int

=example-1 drop

  # given: synopsis

  $redis->drop('zing:main:global:model:temp');

=cut

=method encode

The encode method encodes and returns the data provided as JSON.

=signature encode

encode(HashRef $data) : Str

=example-1 encode

  # given: synopsis

  $redis->encode({ status => 'ok' });

=cut

=method keys

The keys method returns a list of keys under the namespace of the datastore or
provided key.

=signature keys

keys(Str @keys) : ArrayRef[Str]

=example-1 keys

  # given: synopsis

  my $keys = $redis->keys('zing:main:global:model:temp');

=example-2 keys

  # given: synopsis

  $redis->send('zing:main:global:model:temp', { status => 'ok' });

  my $keys = $redis->keys('zing:main:global:model:temp');

=cut

=method rpull

The rpull method pops data off of the bottom of a list in the datastore.

=signature rpull

rpull(Str $key) : Maybe[HashRef]

=example-1 rpull

  # given: synopsis

  $redis->rpull('zing:main:global:model:items');

=example-2 rpull

  # given: synopsis

  $redis->rpush('zing:main:global:model:items', { status => 1 });
  $redis->rpush('zing:main:global:model:items', { status => 2 });

  $redis->rpull('zing:main:global:model:items');

=cut

=method lpull

The lpull method pops data off of the top of a list in the datastore.

=signature lpull

lpull(Str $key) : Maybe[HashRef]

=example-1 lpull

  # given: synopsis

  $redis->lpull('zing:main:global:model:items');

=example-2 lpull

  # given: synopsis

  $redis->rpush('zing:main:global:model:items', { status => 'ok' });

  $redis->lpull('zing:main:global:model:items');

=cut

=method rpush

The rpush method pushed data onto the bottom of a list in the datastore.

=signature rpush

rpush(Str $key, HashRef $val) : Int

=example-1 rpush

  # given: synopsis

  $redis->rpush('zing:main:global:model:items', { status => 'ok' });

=example-2 rpush

  # given: synopsis

  $redis->rpush('zing:main:global:model:items', { status => 'ok' });

  $redis->rpush('zing:main:global:model:items', { status => 'ok' });

=cut

=method decode

The decode method decodes the JSON data provided and returns the data as a hashref.

=signature decode

decode(Str $data) : HashRef

=example-1 decode

  # given: synopsis

  $redis->decode('{"status"=>"ok"}');

=cut

=method recv

The recv method fetches and returns data from the datastore by its key.

=signature recv

recv(Str $key) : Maybe[HashRef]

=example-1 recv

  # given: synopsis

  $redis->recv('zing:main:global:model:temp');

=example-2 recv

  # given: synopsis

  $redis->send('zing:main:global:model:temp', { status => 'ok' });

  $redis->recv('zing:main:global:model:temp');

=cut

=method send

The send method commits data to the datastore with its key and returns truthy.

=signature send

send(Str $key, HashRef $val) : Str

=example-1 send

  # given: synopsis

  $redis->send('zing:main:global:model:temp', { status => 'ok' });

=cut

=method size

The size method returns the size of a list in the datastore.

=signature size

size(Str $key) : Int

=example-1 size

  # given: synopsis

  my $size = $redis->size('zing:main:global:model:items');

=example-2 size

  # given: synopsis

  $redis->rpush('zing:main:global:model:items', { status => 'ok' });

  my $size = $redis->size('zing:main:global:model:items');

=cut

=method slot

The slot method returns the data from a list in the datastore by its index.

=signature slot

slot(Str $key, Int $pos) : Maybe[HashRef]

=example-1 slot

  # given: synopsis

  my $model = $redis->slot('zing:main:global:model:items', 0);

=example-2 slot

  # given: synopsis

  $redis->rpush('zing:main:global:model:items', { status => 'ok' });

  my $model = $redis->slot('zing:main:global:model:items', 0);

=cut

=method test

The test method returns truthy if the specific key (or datastore) exists.

=signature test

test(Str $key) : Int

=example-1 test

  # given: synopsis

  $redis->rpush('zing:main:global:model:items', { status => 'ok' });

  $redis->test('zing:main:global:model:items');

=example-2 test

  # given: synopsis

  $redis->drop('zing:main:global:model:items');

  $redis->test('zing:main:global:model:items');

=cut

=method lpush

The lpush method pushed data onto the top of a list in the datastore.

=signature lpush

lpush(Str $key, HashRef $val) : Int

=example-1 lpush

  # given: synopsis

  $redis->lpush('zing:main:global:model:items', { status => '1' });

=example-2 lpush

  # given: synopsis

  $redis->lpush('zing:main:global:model:items', { status => '0' });

=cut

package main;

my $test = testauto(__FILE__);

my $subs = $test->standard;

{
  my $redis = Zing::Store::Redis->new;
  $redis->drop("zing:main:global:model:temp");
  $redis->drop("zing:main:global:model:items");
}

$subs->synopsis(fun($tryable) {
  ok my $result = $tryable->result;

  $result
});

$subs->example(-1, 'drop', 'method', fun($tryable) {
  ok !(my $result = $tryable->result);
  is $result, 0;

  $result
});

$subs->example(-1, 'encode', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  like $result, qr/status.*=>.*ok/;

  $result
});

$subs->example(-1, 'keys', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is @$result, 0;

  $result
});

$subs->example(-2, 'keys', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is @$result, 1;

  $result
});

$subs->example(-1, 'rpull', 'method', fun($tryable) {
  ok !(my $result = $tryable->result);

  $result
});

$subs->example(-2, 'rpull', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is_deeply $result, {status => 2};

  $result
});

$subs->example(-1, 'lpull', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is_deeply $result, {status => 1};

  $result
});

$subs->example(-2, 'lpull', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is_deeply $result, {status => 'ok'};

  $result
});

$subs->example(-1, 'rpush', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is $result, 1;

  $result
});

$subs->example(-2, 'rpush', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is $result, 3;

  $result
});

$subs->example(-1, 'decode', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is_deeply $result, {status => 'ok'};

  $result
});

$subs->example(-1, 'recv', 'method', fun($tryable) {
  ok my $result = $tryable->result;

  $result
});

$subs->example(-2, 'recv', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is_deeply $result, {status => 'ok'};

  $result
});

$subs->example(-1, 'send', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is $result, 'OK';

  $result
});

$subs->example(-1, 'size', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is $result, 3;

  $result
});

$subs->example(-2, 'size', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is $result, 4;

  $result
});

$subs->example(-1, 'slot', 'method', fun($tryable) {
  ok my $result = $tryable->result;

  $result
});

$subs->example(-2, 'slot', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is_deeply $result, {status => 'ok'};

  $result
});

$subs->example(-1, 'test', 'method', fun($tryable) {
  ok my $result = $tryable->result;

  $result
});

$subs->example(-2, 'test', 'method', fun($tryable) {
  ok !(my $result = $tryable->result);

  $result
});

$subs->example(-1, 'lpush', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is $result, 1;

  $result
});

$subs->example(-2, 'lpush', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is $result, 2;
  my $redis = Zing::Store::Redis->new(
    encoder => Zing::Encoder::Dump->new,
  );
  my $top = $redis->lpull('zing:main:global:model:items');
  is_deeply $top, { status => '0' };

  $result
});

ok 1 and done_testing;
