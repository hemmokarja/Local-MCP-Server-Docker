import logging
import random
import sys

from mcp.server.fastmcp import FastMCP

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    stream=sys.stderr
)
logger = logging.getLogger("dice-server")

mcp = FastMCP("dice")


def _parse_dice_notation(notation):
    """Parse dice notation like 2d6+3 into components"""
    try:
        modifier = 0
        if "+" in notation:
            parts = notation.split("+")
            notation = parts[0]
            modifier = int(parts[1])
        elif "-" in notation:
            parts = notation.split("-")
            notation = parts[0]
            modifier = -int(parts[1])
        
        if "d" in notation.lower():
            parts = notation.lower().split("d")
            num_dice = int(parts[0]) if parts[0] else 1
            sides = int(parts[1])
            return num_dice, sides, modifier
        else:
            # single number means 1 die with that many sides
            return 1, int(notation), modifier
    except:
        return None, None, None


def _format_roll_result(rolls, total, modifier=0):
    if len(rolls) == 1 and modifier == 0:
        return f"🎲 Rolled: {rolls[0]}"

    rolls_str = " + ".join(str(r) for r in rolls)
    if modifier > 0:
        return f"🎲 Rolled: {rolls_str} + {modifier} = **{total}**"
    elif modifier < 0:
        return f"🎲 Rolled: {rolls_str} - {abs(modifier)} = **{total}**"
    else:
        return f"🎲 Rolled: {rolls_str} = **{total}**"


@mcp.tool()
async def roll_dice(notation: str = "1d6") -> str:
    """Roll dice using standard notation like 1d20, 2d6+3, 3d8-2, etc."""
    logger.info(f"Rolling dice: {notation}")
    try:
        if not notation.strip():
            notation = "1d6"

        num_dice, sides, modifier = _parse_dice_notation(notation)
        if num_dice is None:
            return (
                f"❌ Error: Invalid dice notation '{notation}'. "
                "Use format like '2d6' or '1d20+5'"
            )

        if num_dice < 1 or num_dice > 100:
            return "❌ Error: Number of dice must be between 1 and 100"
        if sides < 2 or sides > 1000:
            return "❌ Error: Dice sides must be between 2 and 1000"

        rolls = [random.randint(1, sides) for _ in range(num_dice)]
        total = sum(rolls) + modifier

        result = _format_roll_result(rolls, total, modifier)
        return result

    except Exception as e:
        logger.error(f"Error: {e}")
        return f"❌ Error: {str(e)}"



if __name__ == "__main__":
    logger.info("Starting Dice Roller MCP server...")

    try:
        mcp.run(transport="stdio")
    except Exception as e:
        logger.error(f"Server error: {e}", exc_info=True)
        sys.exit(1)
