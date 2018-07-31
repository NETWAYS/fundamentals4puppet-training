!SLIDE small smbullets
# Syntax and Style

Puppet is as much about syntax as about style

<pre>
type { 'title':
  ensure            => present,
  attribute         => 'value',
  other_attribute   => $variable,
  another_attribute => "${another_var}.txt",
}<br>
file { '/tmp/test':
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  mode    => $file_mode,
  content => "Hello, ${user}!",
}
</pre>

~~~SECTION:handouts~~~

****

Above you can see the basic syntax of a resource in Puppet. First one shows the general schema, second one a example
for a file resource.

The _type_ defines which type of resource is managed, e.g. a _file_ resource, this defines the allowed attributes.
The resource definition is then put in curly brackets. The _title_ is important for naming the resource and is used
to ensure uniqueness. As a simple string the _title_ is put in single quotes. The _title_ is always follow by a colon.
A list of attribute value pairs follows next, always indented by two whitespaces (by style guide) and separated by an
arrow (which should be aligned by style guide). 

~~~PAGEBREAK~~~

There is no particular order required, but if an attribute _ensure_
exists it should be the first, so a reader can easily recognize if a resource is created or removed. The value of the 
attribute should be quoted in single quotes if it is a simple string or in doublequotes if it includes a variable. No
quoting is used for variables or barewords like the state of _ensure_ or a boolean. Resource attributes must have a
trailing comma, including the last one which is again only by style guide and not required by syntax.

Every resource has a so called namevar attribute if not explicitly set the title will be used for its value. In most cases
it is simply the name attribute, but the file resource for example uses the path attribute as namevar.

So the basic syntax is very simple, but Puppet is as much about syntax as about style because it is intended to be
easily readable. Because of this the vendor provides a style guide: https://docs.puppet.com/guides/style_guide.html

~~~ENDSECTION~~~
