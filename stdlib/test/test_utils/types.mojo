# ===----------------------------------------------------------------------=== #
#
# This file is Modular Inc proprietary.
#
# ===----------------------------------------------------------------------=== #


struct MoveOnly[T: Movable](Movable):
    """Utility for testing MoveOnly types.

    Parameters:
        T: Can be any type satisfying the Movable trait.
    """

    var data: T
    """Test data payload."""

    fn __init__(inout self, i: T):
        """Construct a MoveOnly providing the payload data.

        Args:
            i: The test data payload.
        """
        self.data = i^

    fn __moveinit__(inout self, owned other: Self):
        """Move construct a MoveOnly from an existing variable.

        Args:
            other: The other instance that we copying the payload from.
        """
        self.data = other.data^


struct CopyCounter(CollectionElement):
    """Counts the number of copies performed on a value."""

    var copy_count: Int

    fn __init__(inout self):
        self.copy_count = 0

    fn __moveinit__(inout self, owned existing: Self):
        self.copy_count = existing.copy_count

    fn __copyinit__(inout self, existing: Self):
        self.copy_count = existing.copy_count + 1


struct MoveCounter[T: CollectionElement](CollectionElement):
    """Counts the number of moves performed on a value."""

    var value: T
    var move_count: Int

    fn __init__(inout self, owned value: T):
        """Construct a new instance of this type. This initial move is not counted.
        """
        self.value = value^
        self.move_count = 0

    fn __moveinit__(inout self, owned existing: Self):
        self.value = existing.value^
        self.move_count = existing.move_count + 1

    # TODO: This type should not be Copyable, but has to be to satisfy
    #       CollectionElement at the moment.
    fn __copyinit__(inout self, existing: Self):
        # print("ERROR: _MoveCounter copy constructor called unexpectedly!")
        self.value = existing.value
        self.move_count = existing.move_count
