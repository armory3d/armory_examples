from bpy.types import Node
from arm.logicnode.arm_nodes import *
import arm.nodes_logic


class TestNode(ArmLogicTreeNode):
    """Test node"""
    bl_idname = 'LNTestNode'
    bl_label = 'Test'

    # Use this as a tooltip in the add node menu.
    # If `bl_description` does not exist, the docstring of this node is used instead.
    bl_description = 'This is a test node'

    # The category in which this node is listed in the user interface
    arm_category = 'Custom Nodes'

    # Set the version of this node. If you update the node's Python
    # code later, increment this version so that older projects get
    # updated automatically.
    # See https://github.com/armory3d/armory/wiki/logicnodes#node-versioning
    arm_version = 0

    def init(self, context):
        self.add_input('ArmNodeSocketAction', 'In')
        self.add_output('ArmNodeSocketAction', 'Out')


def register():
    """This function is called when Armory loads this library."""

    # Add a new category of nodes in which we will put the TestNode.
    # This step is optional, you can also add nodes to Armory's default
    # categories.
    add_category('Custom Nodes', icon='EVENT_C')

    # Register the TestNode
    TestNode.on_register()
